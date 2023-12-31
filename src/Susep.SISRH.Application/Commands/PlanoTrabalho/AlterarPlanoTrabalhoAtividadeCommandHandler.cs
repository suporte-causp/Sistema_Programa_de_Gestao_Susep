﻿using MediatR;
using Microsoft.AspNetCore.Mvc;
using Susep.SISRH.Application.Queries.Abstractions;
using Susep.SISRH.Domain.AggregatesModel.CatalogoAggregate;
using Susep.SISRH.Domain.AggregatesModel.PlanoTrabalhoAggregate;
using Susep.SISRH.Domain.Exceptions;
using SUSEP.Framework.Data.Abstractions.UnitOfWorks;
using SUSEP.Framework.Result.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Susep.SISRH.Application.Commands.PlanoTrabalho
{
    public class AlterarPlanoTrabalhoAtividadeCommandHandler : IRequestHandler<AlterarPlanoTrabalhoAtividadeCommand, IActionResult>
    {
        private IPlanoTrabalhoRepository PlanoTrabalhoRepository { get; }
        private IUnitOfWork UnitOfWork { get; }

        public AlterarPlanoTrabalhoAtividadeCommandHandler(            
            IPlanoTrabalhoRepository planoTrabalhoRepository, 
            IUnitOfWork unitOfWork)
        {
            PlanoTrabalhoRepository = planoTrabalhoRepository;
            UnitOfWork = unitOfWork;
        }

        public async Task<IActionResult> Handle(AlterarPlanoTrabalhoAtividadeCommand request, CancellationToken cancellationToken)
        {
            ApplicationResult<bool> result = new ApplicationResult<bool>(request);

            try
            {
                IEnumerable<Guid> assuntosId = request.IdsAssuntos != null ? request.IdsAssuntos.ToList() : new List<Guid>();

                //Monta o objeto com os dados do catalogo
                var item = await PlanoTrabalhoRepository.ObterAsync(request.PlanoTrabalhoId);

                IEnumerable<int> criterios = new List<int>();
                if (request.Criterios != null && request.Criterios.Any())
                    criterios = request.Criterios.Select(c => c.CriterioId);

                //Remove a atividade
                item.AlterarAtividade(request.PlanoTrabalhoAtividadeId, request.ModalidadeExecucaoId, request.QuantidadeColaboradores, request.Descricao, request.ItensCatalogo.Select(i => i.ItemCatalogoId), criterios, assuntosId);

                //Altera o item de catalogo no banco de dados
                PlanoTrabalhoRepository.Atualizar(item);
                UnitOfWork.Commit(false);

                result.Result = true;
                result.SetHttpStatusToOk("Plano de trabalho alterado com sucesso.");
            }
            catch (SISRHDomainException ex)
            {
                result.Validations = new List<string>() { ex.Message };
                result.SetHttpStatusToBadRequest(ex.Message);
            }

            return result;
        }
    }
}
