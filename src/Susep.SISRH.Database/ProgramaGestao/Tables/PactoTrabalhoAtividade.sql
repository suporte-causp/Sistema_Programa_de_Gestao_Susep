﻿CREATE TABLE [ProgramaGestao].[PactoTrabalhoAtividade] (
    [pactoTrabalhoAtividadeId] UNIQUEIDENTIFIER NOT NULL,
    [pactoTrabalhoId]          UNIQUEIDENTIFIER NOT NULL,
    [itemCatalogoId]           UNIQUEIDENTIFIER NOT NULL,
    [quantidade]               INT              NOT NULL,
    [tempoPrevistoPorItem]     NUMERIC (4, 1)   NOT NULL,
    [tempoPrevistoTotal]       NUMERIC (4, 1)   NOT NULL,
    [dataInicio]               DATETIME         NULL,
    [dataFim]                  DATETIME         NULL,
    [tempoRealizado]           NUMERIC (4, 1)   NULL,
    [situacaoId]               INT              NOT NULL,
    [descricao]                VARCHAR (2000)   NULL,
    [tempoHomologado]          NUMERIC (4, 1)   NULL,
    [nota]                     NUMERIC (4, 2)   NULL,
    [justificativa]            VARCHAR (200)    NULL,
    [consideracoesConclusao]   VARCHAR (2000)   NULL,
    [modalidadeExecucaoId]     INT              NULL,
    [responsavelAvaliacao]     VARCHAR (50)     NULL,
    [dataAvaliacao]            DATETIME2 (0)    NULL,
    PRIMARY KEY CLUSTERED ([pactoTrabalhoAtividadeId] ASC),
    CONSTRAINT [FK_PactoTrabalhoAtividade_ItemCatalogo] FOREIGN KEY ([itemCatalogoId]) REFERENCES [ProgramaGestao].[ItemCatalogo] ([itemCatalogoId]),
    CONSTRAINT [FK_PactoTrabalhoAtividade_PactoTrabalho] FOREIGN KEY ([pactoTrabalhoId]) REFERENCES [ProgramaGestao].[PactoTrabalho] ([pactoTrabalhoId]),
    CONSTRAINT [FK_PactoTrabalhoAtividade_Situacao] FOREIGN KEY ([situacaoId]) REFERENCES [dbo].[CatalogoDominio] ([catalogoDominioId])
);














GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nota da avaliação após a conclusão da atividade.', @level0type = N'SCHEMA', @level0name = N'ProgramaGestao', @level1type = N'TABLE', @level1name = N'PactoTrabalhoAtividade', @level2type = N'COLUMN', @level2name = N'nota';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Justificativa para a nota de avaliação baixa.', @level0type = N'SCHEMA', @level0name = N'ProgramaGestao', @level1type = N'TABLE', @level1name = N'PactoTrabalhoAtividade', @level2type = N'COLUMN', @level2name = N'justificativa';








GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Detalhes que o servidor fornece sobre a atividade ao concluir sua execução.', @level0type = N'SCHEMA', @level0name = N'ProgramaGestao', @level1type = N'TABLE', @level1name = N'PactoTrabalhoAtividade', @level2type = N'COLUMN', @level2name = N'consideracoesConclusao';




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tempo homologado para a realização da atividade.', @level0type = N'SCHEMA', @level0name = N'ProgramaGestao', @level1type = N'TABLE', @level1name = N'PactoTrabalhoAtividade', @level2type = N'COLUMN', @level2name = N'tempoHomologado';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Responsável pela avaliação da atividade', @level0type = N'SCHEMA', @level0name = N'ProgramaGestao', @level1type = N'TABLE', @level1name = N'PactoTrabalhoAtividade', @level2type = N'COLUMN', @level2name = N'responsavelAvaliacao';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Registra a modalidade em que a atividade foi executada', @level0type = N'SCHEMA', @level0name = N'ProgramaGestao', @level1type = N'TABLE', @level1name = N'PactoTrabalhoAtividade', @level2type = N'COLUMN', @level2name = N'modalidadeExecucaoId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data da avaliação da atividade', @level0type = N'SCHEMA', @level0name = N'ProgramaGestao', @level1type = N'TABLE', @level1name = N'PactoTrabalhoAtividade', @level2type = N'COLUMN', @level2name = N'dataAvaliacao';

