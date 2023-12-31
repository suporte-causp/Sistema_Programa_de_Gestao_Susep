import { Component, OnInit, Input } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { IPactoTrabalho, IPactoTrabalhoAtividade } from '../../../../models/pacto-trabalho.model';
import { PactoTrabalhoDataService } from '../../../../services/pacto-trabalho.service';
import { CdkDragDrop, moveItemInArray, transferArrayItem, CdkDrag } from '@angular/cdk/drag-drop';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'atividade-pacto-kanban',
  templateUrl: './atividade-kanban.component.html',
  styleUrls: ['./atividade-kanban.component.css'],
})
export class AtividadesPactoKanbanComponent implements OnInit {

  todo: IPactoTrabalhoAtividade[];
  doing: IPactoTrabalhoAtividade[];
  done: IPactoTrabalhoAtividade[];

  @Input() dadosPacto: BehaviorSubject<IPactoTrabalho>;

  constructor(
    private toastr: ToastrService,
    private pactoTrabalhoDataService: PactoTrabalhoDataService,) { }

  ngOnInit() {

    this.dadosPacto.subscribe(val => this.carregarAtividades());

  }

  carregarAtividades() {
    this.pactoTrabalhoDataService.ObterAtividades(this.dadosPacto.value.pactoTrabalhoId).subscribe(
      resultado => {
        this.dadosPacto.value.atividades = resultado.retorno;

        this.todo = this.dadosPacto.value.atividades.filter(a => a.situacaoId === 501);
        this.doing = this.dadosPacto.value.atividades.filter(a => a.situacaoId === 502);
        this.done = this.dadosPacto.value.atividades.filter(a => a.situacaoId === 503);
      }
    );
  }

  drop(event: CdkDragDrop<string[]>) {

    if (event.previousContainer === event.container) {
      moveItemInArray(event.container.data, event.previousIndex, event.currentIndex);
    } else {

      //Evita que mova direto de TODO para DONE
      if (event.previousContainer.id === "todoList" && event.container.id === "doneList") {
        this.toastr.warning("Não é possível passar diretamente de pendente para concluído.");
        return;
      }

      //Evita que muda para concluído sem informar a descrição da entrega
      const atividade = this.dadosPacto.value.atividades.filter(at => at.pactoTrabalhoAtividadeId === event.item.data.pactoTrabalhoAtividadeId)[0];
      const descricaoAtividadePreenchida = atividade.consideracoes;
      if (event.container.id === "doneList" && !descricaoAtividadePreenchida) {
        this.toastr.warning("É obrigatório informar a descrição da atividade antes de concluir sua execução");
        return;
      }

      transferArrayItem(event.previousContainer.data,
        event.container.data,
        event.previousIndex,
        event.currentIndex);

      let acao: 'todo' | 'doing' | 'done';
      switch (event.container.id) {
        case "todoList": acao = 'todo'; break;
        case "doingList": acao = 'doing'; break;
        case "doneList": acao = 'done'; break;
      }

      this.pactoTrabalhoDataService.AlterarAtividadeKanban(this.dadosPacto.value.pactoTrabalhoId, event.item.data.pactoTrabalhoAtividadeId, acao).subscribe(
        resultado => {
          this.carregarAtividades();
        }
      );
    }
  }

  evenPredicate(item: CdkDrag<number>) {
    return true;
  }


}

