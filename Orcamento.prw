#include "protheus.ch"
#include 'parmtype.ch'

/*/{Protheus.doc} OrcXreal
Relatório de apuração de Orçamento X Realizado
@author  João Paulo	
@since   23/07/2019
@version P12 V1.17
/*/
User Function OrcXreal()
	Local cPerg		:= "OrcXreal"
	Local cDirPad	:= GetTempPath(.T.)
	Local bOk		:= {|lEnd, cArquivo| ProcRel(lEnd, cArquivo)}
	Local cTitulo	:= "Orcamento x Realizado"
	Local cArqRel	:= "OrcXreal_" + DToS(Date()) + "_" + StrTran(Time(),":","")
	Local cDescr	:= "Esta rotina tem como objetivo criar um arquivo no formato XML com os calculos de Orcamento x Realizado."
	Local cTipoArq	:= "xml"
	Local nOpcPad	:= 1
	Local cMsgProc	:= "Por favor Aguarde. Processando o relatorio..."

	AjustaSX1(@cPerg)

	U_XMLPerg(cPerg, cDirPad, bOk, cTitulo, cArqRel, cDescr, cTipoArq, nOpcPad, cMsgProc)
Return

/*/
Fluxo de preparação do relatório.
/*/
Static Function ProcRel(lEnd, cArquivo)
	Local aFilImp	:= {}
	Local aRow		:= {}
	Local aStyle	:= {}
	Local aMerge	:= {}
	Local aAux		:= {}
	Local aColsSize	:= {}
	Local nX		:= 0
	Local cXml		:= ""
	Local oXML		:= Nil

	Static oTitle	:= Nil
	Static oSubTit	:= Nil
	Static oContab	:= Nil
	Static oPerSDec	:= Nil
	Static oPerCDec	:= Nil
	Static oNaoUsa	:= Nil
    
	Aadd(aFilImp, FWcodfil())

	If Len(aFilImp) > 0
		oTitle		:= GetCellSty(1) // Célula do título
		oSubTit		:= GetCellSty(2) // Célula de sub-título
		oContab		:= GetCellSty(3) // Célula normal contabil
		oPerSDec	:= GetCellSty(4) // Célula normal percentual sem decimal
		oPerCDec	:= GetCellSty(5) // Célula normal percentual com decimal
		oNaoUsa		:= GetCellSty(6) // Célula normal nao usada
		oCtbNEdit	:= GetCellSty(7) // Célula contabil nao editavel

		oXML := ExcelXML():New()

		oXml:setFolder(1)
		oXml:setFolderName("Orc x Realizado")
		oXml:showGridLine(.F.)
		oXml:SetZoom(100)

		AAdd(aRow	, Array(((Len(aFilImp)*2) + 4), ""))
		AAdd(aStyle	, oTitle)
		AAdd(aMerge	, {Nil, 1, Nil, Len(aRow[1])-1})

		aRow[1,1] := "Orcado X Realizado - " + DToC(MV_PAR01) + " de " + DToC(MV_PAR02)

		aAux := {"Referencia", ""}

		For nX := 1 To Len(aFilImp)
			Aadd(aAux, aFilImp[nX] + " - " + FWFilName(FWCodEmp(), aFilImp[nX]))
			Aadd(aAux, "%")
		Next nX
		Aadd(aAux, "Total Geral")
   		Aadd(aAux, "%")

		AAdd(aRow	, aAux)
		AAdd(aStyle	, oTitle)
		AAdd(aMerge	, {Nil, 1, Nil, 1})

		// Receita (Total de Vendas)
		GetTotVnd(aFilImp, @aRow, @aStyle, @aMerge)

		// Imposto sobre Vendas
		GetImpVnd(aFilImp, @aRow, @aStyle, @aMerge)

		// Fornecedores
		GetFornece(aFilImp, @aRow, @aStyle, @aMerge)

		// Margem Bruta
		GetMargBrt(aFilImp, @aRow, @aStyle, @aMerge)

		// Despesas Operacionais
		GetDespOpe(aFilImp, @aRow, @aStyle, @aMerge)

		// Receita Financeira
		GetRecFin(aFilImp, @aRow, @aStyle, @aMerge)

		// Despesas Financeira
		GetDesFin(aFilImp, @aRow, @aStyle, @aMerge)

		// Perda Inadimpl?ncia
		GetPerInad(aFilImp, @aRow, @aStyle, @aMerge)

		// Recupera??o de Perdas
		GetRecPerd(aFilImp, @aRow, @aStyle, @aMerge)

		// Falta Balan?o
		GetFaltaBa(aFilImp, @aRow, @aStyle, @aMerge)

		// Sobra Balan?o
		GetSobraBa(aFilImp, @aRow, @aStyle, @aMerge)

		// Resultado Operacional
		GetResulOp(aFilImp, @aRow, @aStyle, @aMerge)

		// Escrit?rio Central
		GetEscCent(aFilImp, @aRow, @aStyle, @aMerge)

		// Dep. de Compras
		GetDepComp(aFilImp, @aRow, @aStyle, @aMerge)

		// Dep. de Marketing
		GetDepMkt(aFilImp, @aRow, @aStyle, @aMerge)

		// Impostos
		GetImposto(aFilImp, @aRow, @aStyle, @aMerge)

		// Resultado L?quido
		GetResLiq(aFilImp, @aRow, @aStyle, @aMerge)

		// Investimento
		GetInvest(aFilImp, @aRow, @aStyle, @aMerge)

		// Resultado Final
		GetResFina(aFilImp, @aRow, @aStyle, @aMerge)

		For nX := 1 To Len(aRow)
			If ValType(aRow[nX]) == "A" .And. ValType(aStyle[nX]) $ "A|O"
				oXML:AddRow(, aRow[nX], aStyle[nX])

				If ValType(aMerge[nX]) == "A"
					If Len(aMerge[nX]) == 4
						oXML:SetMerge(aMerge[nX,1], aMerge[nX,2], aMerge[nX,3], aMerge[nX,4])
					EndIf
				EndIf
			EndIf
		Next nX

		aColsSize := Array(Len(aRow[1]), "100")
		aColsSize[1] := "150"
		aColsSize[2] := "50"

		oXml:SetColSize(aColsSize)

		cXml := oXML:GetXML(cArquivo)
	Else
		HELP(' ',1,"Planilha Orcamentaria" ,,"Nenhuma empresa configurada para impressao",2,0,,,,,, {"Informe o Administrador do sistema."})
	EndIf
Return cXml

/*/
Retorna o estilo de uma célula.
/*/
Static Function GetCellSty(nOpc)
	Local oCellSty	:= Nil

	Default nOpc	:= 0

	Do Case
		Case nOpc == 1 // Célula do título
			oCellSty := CellStyle():New("TitCell")
			oCellSty:SetHAlign("Center")
			oCellSty:SetVAlign("Center")
			oCellSty:SetBorder("All", "Continuous")
			oCellSty:SetFont("CALIBRI",11,"#000000", .T.)
			oCellSty:SetInterior("#dddddd", "Solid")
			oCellSty:SetWrapText(.T.)

		Case nOpc == 2 // Célula de sub-título
			oCellSty := CellStyle():New("SubTitCell")
			oCellSty:SetHAlign("Left")
			oCellSty:SetVAlign("Center")
			oCellSty:SetBorder("All", "Continuous")
			oCellSty:SetFont("CALIBRI",10,"#000000", .T.)
			oCellSty:SetInterior("#ffffff", "Solid")
			oCellSty:SetWrapText(.T.)

		Case nOpc == 3 // Célula normal contabil
			oCellSty := CellStyle():New("ContabilCell")
			oCellSty:SetHAlign("Center")
			oCellSty:SetVAlign("Center")
			oCellSty:SetBorder("All", "Continuous")
			oCellSty:SetFont("CALIBRI",10,"#000000", .T.)
			oCellSty:SetInterior("#ffffff", "Solid")
			oCellSty:SetWrapText(.T.)
			oCellSty:SetNumberFormat('_-&quot;R$&quot;* #,##0.00_-;\-&quot;R$&quot;* #,##0.00_-;_-&quot;R$&quot;* &quot;-&quot;??_-;_-@_-')

		Case nOpc == 4 // Célula normal percentual sem decimal
			oCellSty := CellStyle():New("PercentCellSemDec")
			oCellSty:SetHAlign("Center")
			oCellSty:SetVAlign("Center")
			oCellSty:SetBorder("All", "Continuous")
			oCellSty:SetFont("CALIBRI",10,"#000000", .T.)
			oCellSty:SetInterior("#ffffff", "Solid")
			oCellSty:SetWrapText(.T.)
			oCellSty:SetNumberFormat('0%')

		Case nOpc == 5 // Célula normal percentual com decimal
			oCellSty := CellStyle():New("PercentCellComDec")
			oCellSty:SetHAlign("Center")
			oCellSty:SetVAlign("Center")
			oCellSty:SetBorder("All", "Continuous")
			oCellSty:SetFont("CALIBRI",10,"#000000", .T.)
			oCellSty:SetInterior("#ffffff", "Solid")
			oCellSty:SetWrapText(.T.)
			oCellSty:SetNumberFormat('0.0%')

		Case nOpc == 6 // Célula normal nao usada
			oCellSty := CellStyle():New("NaoUsadaCell")
			oCellSty:SetHAlign("Center")
			oCellSty:SetVAlign("Center")
			oCellSty:SetBorder("All", "Continuous")
			oCellSty:SetFont("CALIBRI",10,"#dddddd", .T.)
			oCellSty:SetInterior("#dddddd", "Solid")
			oCellSty:SetWrapText(.T.)

		Case nOpc == 7 // Célula contabil nao editavel
			oCellSty := CellStyle():New("NotEditContabilCell")
			oCellSty:SetHAlign("Center")
			oCellSty:SetVAlign("Center")
			oCellSty:SetBorder("All", "Continuous")
			oCellSty:SetFont("CALIBRI",10,"#000000", .T.)
			oCellSty:SetInterior("#dddddd", "Solid")
			oCellSty:SetWrapText(.T.)
			oCellSty:SetNumberFormat('_-&quot;R$&quot;* #,##0.00_-;\-&quot;R$&quot;* #,##0.00_-;_-&quot;R$&quot;* &quot;-&quot;??_-;_-@_-')

		OtherWise // Gen?rica
			oCellSty := CellStyle():New("GenericCell")
			oCellSty:SetHAlign("left")
			oCellSty:SetBorder("All", "Continuous")
			oCellSty:SetFont("CALIBRI",10,"#000000", .T.)
			oCellSty:SetInterior("#ffffff", "Solid")
			oCellSty:SetWrapText(.T.)
	EndCase
Return oCellSty

/*/{Protheus.doc} GetTotVnd
Processa a linha de Receita (Total de Vendas) do relatório.
/*/
Static Function GetTotVnd(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_POTOTVD', .F., '10200')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 1)
		aValReal := GetFatReal()

		aLinOrc		:= {{"Receita (Total de Vendas)", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "")
			AAdd(aLinOrc[2], oNaoUsa)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "")
			AAdd(aLinReal[2], oNaoUsa)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "")
		AAdd(aLinOrc[2], oNaoUsa)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "")
		AAdd(aLinReal[2], oNaoUsa)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Imposto sobre Vendas do relatório.
/*/
Static Function GetImpVnd(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_POIMPVD', .F., '20502|20503')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 2)
		aValReal := GetValReal(cContas, 2)

		aLinOrc		:= {{"Imposto sobre Vendas", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-3]C[-1]=0,0,RC[-1]/R[-3]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-3]C[-1]=0,0,RC[-1]/R[-3]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-3]C[-1]=0,0,RC[-1]/R[-3]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-3]C[-1]=0,0,RC[-1]/R[-3]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Fornecedores do relatório.
/*/
Static Function GetFornece(aFilImp, aRow, aStyle, aMerge)
	Local cContRec	:= GetMv('DD_POFORRE', .F., '10210|10214')
	Local cContDes	:= GetMv('DD_POFORDE', .F., '20601|20604')
	Local aVOrcRec	:= {}
	Local aVOrcDes	:= {}
	Local aVRealRec	:= {}
	Local aVRealDes	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPosRec	:= 0
	Local nPosDes	:= 0
	Local nValRec	:= 0
	Local nValDes	:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aVOrcRec := GetValOrc(cContRec, 1)
		aVOrcDes := GetValOrc(cContDes, 2)
		aVRealRec := GetValReal(cContRec, 1)
		aVRealDes := GetValReal(cContDes, 2)

		aLinOrc		:= {{"Fornecedores", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPosRec := AScan(aVOrcRec, {|aX| aX[1] == aFilImp[nX]})
			nValRec := IIF((nPosRec > 0), aVOrcRec[nPosRec, 2], 0)

			nPosDes := AScan(aVOrcDes, {|aX| aX[1] == aFilImp[nX]})
			nValDes := IIF((nPosDes > 0), aVOrcDes[nPosDes, 2], 0)

			AAdd(aLinOrc[1], (nValDes - nValRec))
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-6]C[-1]=0,0,RC[-1]/R[-6]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPosRec := AScan(aVRealRec, {|aX| aX[1] == aFilImp[nX]})
			nValRec := IIF((nPosRec > 0), aVRealRec[nPosRec, 2], 0)

			nPosDes := AScan(aVRealDes, {|aX| aX[1] == aFilImp[nX]})
			nValDes := IIF((nPosDes > 0), aVRealDes[nPosDes, 2], 0)

			AAdd(aLinReal[1], (nValDes - nValRec))
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-6]C[-1]=0,0,RC[-1]/R[-6]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-6]C[-1]=0,0,RC[-1]/R[-6]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-6]C[-1]=0,0,RC[-1]/R[-6]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return


/*/
Processa a linha de Margem Bruta do relatório.
/*/
Static Function GetMargBrt(aFilImp, aRow, aStyle, aMerge)
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aLinOrc		:= {{"Margem Bruta", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			AAdd(aLinOrc[1], "=R[-9]C-R[-6]C-R[-3]C")
			AAdd(aLinOrc[2], oCtbNEdit)
			AAdd(aLinOrc[1], "=IF(R[-9]C[-1]=0,0,RC[-1]/R[-9]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			AAdd(aLinReal[1], "=R[-9]C-R[-6]C-R[-3]C")
			AAdd(aLinReal[2], oCtbNEdit)
			AAdd(aLinReal[1], "=IF(R[-9]C[-1]=0,0,RC[-1]/R[-9]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oCtbNEdit)
		AAdd(aLinOrc[1], "=IF(R[-9]C[-1]=0,0,RC[-1]/R[-9]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oCtbNEdit)
		AAdd(aLinReal[1], "=IF(R[-9]C[-1]=0,0,RC[-1]/R[-9]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Despesas Operacionais do relatório.
/*/
Static Function GetDespOpe(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_PODESOP', .F., '20104|20102|20103|20101|20109|20105|20122|20123|20108|20301|20304|20305|20401|20117|20106|20111|20302|20402|20118|20113|20110|20115|20116')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 2)
		aValReal := GetValReal(cContas, 2)

		aLinOrc		:= {{"Despesas Operacionais", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-12]C[-1]=0,0,RC[-1]/R[-12]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-12]C[-1]=0,0,RC[-1]/R[-12]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-12]C[-1]=0,0,RC[-1]/R[-12]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-12]C[-1]=0,0,RC[-1]/R[-12]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Receita Financeira do relatório.
/*/
Static Function GetRecFin(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_PORECFI', .F., '10215')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 1)
		aValReal := GetValReal(cContas, 1)

		aLinOrc		:= {{"Receita Financeira", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-15]C[-1]=0,0,RC[-1]/R[-15]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-15]C[-1]=0,0,RC[-1]/R[-15]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-15]C[-1]=0,0,RC[-1]/R[-15]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-15]C[-1]=0,0,RC[-1]/R[-15]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Despesas Financeira do relatório.
/*/
Static Function GetDesFin(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_PODESFI', .F., '20201')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 2)
		aValReal := GetValReal(cContas, 2)

		aLinOrc		:= {{"Despesas Financeira", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-18]C[-1]=0,0,RC[-1]/R[-18]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-18]C[-1]=0,0,RC[-1]/R[-18]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-18]C[-1]=0,0,RC[-1]/R[-18]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-18]C[-1]=0,0,RC[-1]/R[-18]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Perda Inadimplência do relatório.
/*/
Static Function GetPerInad(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_POPERIN', .F., '20119')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 2)
		aValReal := GetValReal(cContas, 2)

		aLinOrc		:= {{"Perda Inadimplencia", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-21]C[-1]=0,0,RC[-1]/R[-21]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-21]C[-1]=0,0,RC[-1]/R[-21]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-21]C[-1]=0,0,RC[-1]/R[-21]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-21]C[-1]=0,0,RC[-1]/R[-21]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return


/*/
Processa a linha de Recuperação de Perdas do relatório.
/*/
Static Function GetRecPerd(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_PORECPE', .F., '10216')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 1)
		aValReal := GetValReal(cContas, 1)

		aLinOrc		:= {{"Recuperacao de Perdas", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-24]C[-1]=0,0,RC[-1]/R[-24]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-24]C[-1]=0,0,RC[-1]/R[-24]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-24]C[-1]=0,0,RC[-1]/R[-24]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-24]C[-1]=0,0,RC[-1]/R[-24]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return


/*/
Processa a linha de Falta Balan?o do relatório.
/*/
Static Function GetFaltaBa(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_POFALBA', .F., '20606')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 2)
		aValReal := GetValReal(cContas, 2)

		aLinOrc		:= {{"Falta Balanco", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-27]C[-1]=0,0,RC[-1]/R[-27]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-27]C[-1]=0,0,RC[-1]/R[-27]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-27]C[-1]=0,0,RC[-1]/R[-27]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-27]C[-1]=0,0,RC[-1]/R[-27]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Sobra Balan?o do relatório.
/*/
Static Function GetSobraBa(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_POSOBBA', .F., '10213')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 1)
		aValReal := GetValReal(cContas, 1)

		aLinOrc		:= {{"Sobra Balanco", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-30]C[-1]=0,0,RC[-1]/R[-30]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-30]C[-1]=0,0,RC[-1]/R[-30]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-30]C[-1]=0,0,RC[-1]/R[-30]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-30]C[-1]=0,0,RC[-1]/R[-30]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Resultado Operacional do relatório.
/*/
Static Function GetResulOp(aFilImp, aRow, aStyle, aMerge)
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aLinOrc		:= {{"Resultado Operacional", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			AAdd(aLinOrc[1], "=(R[-24]C+R[-18]C+R[-9]C+R[-3]C)-(R[-21]C+R[-15]C+R[-12]C+R[-6]C)")
			AAdd(aLinOrc[2], oCtbNEdit)
			AAdd(aLinOrc[1], "=IF(R[-33]C[-1]=0,0,RC[-1]/R[-33]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			AAdd(aLinReal[1], "=(R[-24]C+R[-18]C+R[-9]C+R[-3]C)-(R[-21]C+R[-15]C+R[-12]C+R[-6]C)")
			AAdd(aLinReal[2], oCtbNEdit)
			AAdd(aLinReal[1], "=IF(R[-33]C[-1]=0,0,RC[-1]/R[-33]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oCtbNEdit)
		AAdd(aLinOrc[1], "=IF(R[-33]C[-1]=0,0,RC[-1]/R[-33]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oCtbNEdit)
		AAdd(aLinReal[1], "=IF(R[-33]C[-1]=0,0,RC[-1]/R[-33]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Escrit?rio Central do relatório.
/*/
Static Function GetEscCent(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_POESCCE', .F., '20120')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 2)
		aValReal := GetValReal(cContas, 2)

		aLinOrc		:= {{"Escritorio Central", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-36]C[-1]=0,0,RC[-1]/R[-36]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-36]C[-1]=0,0,RC[-1]/R[-36]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-36]C[-1]=0,0,RC[-1]/R[-36]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-36]C[-1]=0,0,RC[-1]/R[-36]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Dep. de Compras do relatório.
/*/
Static Function GetDepComp(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_PODEPCP', .F., '20124')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 2)
		aValReal := GetValReal(cContas, 2)

		aLinOrc		:= {{"Dep. de Compras", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-39]C[-1]=0,0,RC[-1]/R[-39]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-39]C[-1]=0,0,RC[-1]/R[-39]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-39]C[-1]=0,0,RC[-1]/R[-39]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-39]C[-1]=0,0,RC[-1]/R[-39]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Dep. de Marketing do relatório.
/*/
Static Function GetDepMkt(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_PODEPMK', .F., '20125')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 2)
		aValReal := GetValReal(cContas, 2)

		aLinOrc		:= {{"Dep. de Marketing", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-42]C[-1]=0,0,RC[-1]/R[-42]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-42]C[-1]=0,0,RC[-1]/R[-42]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-42]C[-1]=0,0,RC[-1]/R[-42]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-42]C[-1]=0,0,RC[-1]/R[-42]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Impostos do relatório.
/*/
Static Function GetImposto(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_POIMPOS', .F., '20501')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 2)
		aValReal := GetValReal(cContas, 2)

		aLinOrc		:= {{"Impostos", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-45]C[-1]=0,0,RC[-1]/R[-45]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-45]C[-1]=0,0,RC[-1]/R[-45]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-45]C[-1]=0,0,RC[-1]/R[-45]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-45]C[-1]=0,0,RC[-1]/R[-45]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Resultado L?quido do relatório.
/*/
Static Function GetResLiq(aFilImp, aRow, aStyle, aMerge)
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aLinOrc		:= {{"Resultado Liquido", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			AAdd(aLinOrc[1], "=(R[-15]C-R[-12]C-R[-9]C-R[-6]C-R[-3]C)")
			AAdd(aLinOrc[2], oCtbNEdit)
			AAdd(aLinOrc[1], "=IF(R[-48]C[-1]=0,0,RC[-1]/R[-48]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			AAdd(aLinReal[1], "=(R[-15]C-R[-12]C-R[-9]C-R[-6]C-R[-3]C)")
			AAdd(aLinReal[2], oCtbNEdit)
			AAdd(aLinReal[1], "=IF(R[-48]C[-1]=0,0,RC[-1]/R[-48]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oCtbNEdit)
		AAdd(aLinOrc[1], "=IF(R[-48]C[-1]=0,0,RC[-1]/R[-48]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oCtbNEdit)
		AAdd(aLinReal[1], "=IF(R[-48]C[-1]=0,0,RC[-1]/R[-48]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Investimento do relatório.
/*/
Static Function GetInvest(aFilImp, aRow, aStyle, aMerge)
	Local cContas	:= GetMv('DD_POINVES', .F., '20112')
	Local aValOrc	:= {}
	Local aValReal	:= {}
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local nPos		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aValOrc := GetValOrc(cContas, 2)
		aValReal := GetValReal(cContas, 2)

		aLinOrc		:= {{"Investimento", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			nPos := AScan(aValOrc, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinOrc[1], aValOrc[nPos, 2])
			Else
				AAdd(aLinOrc[1], 0)
			EndIf
			AAdd(aLinOrc[2], oContab)
			AAdd(aLinOrc[1], "=IF(R[-51]C[-1]=0,0,RC[-1]/R[-51]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			nPos := AScan(aValReal, {|aX| aX[1] == aFilImp[nX]})

			If nPos > 0
				AAdd(aLinReal[1], aValReal[nPos, 2])
			Else
				AAdd(aLinReal[1], 0)
			EndIf
			AAdd(aLinReal[2], oContab)
			AAdd(aLinReal[1], "=IF(R[-51]C[-1]=0,0,RC[-1]/R[-51]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oContab)
		AAdd(aLinOrc[1], "=IF(R[-51]C[-1]=0,0,RC[-1]/R[-51]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oContab)
		AAdd(aLinReal[1], "=IF(R[-51]C[-1]=0,0,RC[-1]/R[-51]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Processa a linha de Resultado Final do relatório.
/*/
Static Function GetResFina(aFilImp, aRow, aStyle, aMerge)
	Local aLinOrc	:= {}
	Local aLinReal	:= {}
	Local aLinVar	:= {}
	Local nX		:= 0
	Local cFormTot	:= ""

	Default aFilImp	:= {}
	Default aRow	:= {}
	Default aStyle	:= {}
	Default aMerge	:= {}

	If !(Empty(aFilImp))
		aLinOrc		:= {{"Resultado Final", "Orcado"}, {oTitle, oSubTit}}
		aLinReal	:= {{"", "Realizado"}, {oTitle, oSubTit}}
		aLinVar		:= {{"", "Variacao"}, {oTitle, oSubTit}}

		For nX := 1 To Len(aFilImp)
			AAdd(aLinOrc[1], "=(R[-6]C-R[-3]C)")
			AAdd(aLinOrc[2], oCtbNEdit)
			AAdd(aLinOrc[1], "=IF(R[-54]C[-1]=0,0,RC[-1]/R[-54]C[-1])")
			AAdd(aLinOrc[2], oPerCDec)

			AAdd(aLinReal[1], "=(R[-6]C-R[-3]C)")
			AAdd(aLinReal[2], oCtbNEdit)
			AAdd(aLinReal[1], "=IF(R[-54]C[-1]=0,0,RC[-1]/R[-54]C[-1])")
			AAdd(aLinReal[2], oPerCDec)

			AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
			AAdd(aLinVar[2], oPerSDec)
			AAdd(aLinVar[1], "")
			AAdd(aLinVar[2], oNaoUsa)
		Next nX

		cFormTot := ""
		For nX := (Len(aLinOrc[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinOrc[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinOrc[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinOrc[2], oCtbNEdit)
		AAdd(aLinOrc[1], "=IF(R[-54]C[-1]=0,0,RC[-1]/R[-54]C[-1])")
		AAdd(aLinOrc[2], oPerCDec)

		cFormTot := ""
		For nX := (Len(aLinReal[1]) - 2) To 1 Step -2
			If mod(nX, 2) == 0 // ? par
				If nX < (Len(aLinReal[1]) - 2)
					cFormTot += ","
				EndIf

				cFormTot += "RC[-" + AllTrim(cValToChar(nX)) + "]"
			EndIf
		Next nX
		Aadd(aLinReal[1], "=SUM(" + cFormTot + ")")
		AAdd(aLinReal[2], oCtbNEdit)
		AAdd(aLinReal[1], "=IF(R[-54]C[-1]=0,0,RC[-1]/R[-54]C[-1])")
		AAdd(aLinReal[2], oPerCDec)

		AAdd(aLinVar[1], '=IF(R[-2]C=0,0,R[-1]C/R[-2]C)')
		AAdd(aLinVar[2], oPerSDec)
		AAdd(aLinVar[1], "")
		AAdd(aLinVar[2], oNaoUsa)

		AAdd(aRow	, aLinOrc[1])
		AAdd(aStyle	, aLinOrc[2])
		AAdd(aMerge	, {Nil, Nil, 2, 0})

		AAdd(aRow	, aLinReal[1])
		AAdd(aStyle	, aLinReal[2])
		AAdd(aMerge	, {})

		AAdd(aRow	, aLinVar[1])
		AAdd(aStyle	, aLinVar[2])
		AAdd(aMerge	, {})
	EndIf
Return

/*/
Retorna o valor or?ado de um determinado grupo de contas.
/*/
Static Function GetValOrc(cContas, nTipo)
	Local aRet		:= {}
	Local cQuery 	:= ""
	Local cTmpAlias	:= ""
	Local cNoFil	:= GetMv('DD_POFILDE', .F., '')

	Default cContas	:= ""
	Default nTipo	:= 1 // 1 = Receita; 2 = Despesa

	If !(Empty(cContas))
		cQuery := "SELECT AK2.AK2_FILIAL " + CRLF
		cQuery += "	,ISNULL(SUM(AK2.AK2_VALOR), 0) VALORC " + CRLF
		cQuery += "FROM " + RetSqlName("AK2") + " AK2 (NOLOCK) " + CRLF
		cQuery += "WHERE AK2.AK2_ORCAME = '" + IIF(nTipo == 1, MV_PAR03, MV_PAR05) + "' " + CRLF
		cQuery += "	AND AK2.AK2_VERSAO = '" + IIF(nTipo == 1, MV_PAR04, MV_PAR06) + "' " + CRLF
		cQuery += "	AND AK2.AK2_PERIOD >= '" + DtoS(MV_PAR01) + "' " + CRLF
		cQuery += "	AND AK2.AK2_PERIOD <= '" + DtoS(MV_PAR02) + "' " + CRLF

		If !(Empty(cNoFil))
			cQuery += "	AND AK2.AK2_FILIAL NOT IN" + FormatIn(cNoFil, '|') + " " + CRLF
		EndIf

		cQuery += "	AND AK2.AK2_CO IN" + FormatIn(cContas, '|') + " " + CRLF
		cQuery += "	AND AK2.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += "GROUP BY AK2.AK2_FILIAL " + CRLF
		cQuery += "ORDER BY AK2.AK2_FILIAL " + CRLF

		cTmpAlias := GetNextAlias()

		If Select(cTmpAlias) > 0
			(cTmpAlias)->(DbCloseArea())
		EndIf

		DbUseArea(.T., 'TOPCONN', TCGenQry(,, cQuery), cTmpAlias, .F., .T.)

		While !((cTmpAlias)->(Eof()))
			Aadd(aRet, {(cTmpAlias)->AK2_FILIAL, (cTmpAlias)->VALORC})

			(cTmpAlias)->(DbSkip())
		EndDo

		If Select(cTmpAlias) > 0
			(cTmpAlias)->(DbCloseArea())
		EndIf
	EndIf
Return aRet

/*/
Retorna o valor realizado de um determinado grupo de contas.
/*/
Static Function GetValReal(cContas, nTipo)
	Local aRet		:= {}
	Local cQuery 	:= ""
	Local cTmpAlias	:= ""
	Local cNoFil	:= GetMv('DD_POFILDE', .F., '')
	Local cTipoSld	:= GetMv('DD_POTPSLD', .F., '')

	Default cContas	:= ""
	Default nTipo	:= 1 // 1 = Receita; 2 = Despesa

	If !(Empty(cContas))
		cQuery := "SELECT AKD.AKD_FILIAL " + CRLF
		cQuery += "	,ISNULL(SUM(AKD.AKD_VALOR1), 0) VALREAL " + CRLF
		cQuery += "FROM " + RetSqlName("AKD") + " AKD (NOLOCK) " + CRLF
		cQuery += "WHERE AKD.AKD_CODPLA = '" + IIF(nTipo == 1, MV_PAR03, MV_PAR05) + "' " + CRLF
		cQuery += "	AND AKD.AKD_VERSAO = '" + IIF(nTipo == 1, MV_PAR04, MV_PAR06) + "' " + CRLF
		cQuery += "	AND AKD.AKD_DATA >= '" + DtoS(MV_PAR01) + "' " + CRLF
		cQuery += "	AND AKD.AKD_DATA <= '" + DtoS(MV_PAR02) + "' " + CRLF

		If !(Empty(cTipoSld))
			cQuery += "	AND AKD.AKD_TPSALD IN" + FormatIn(cTipoSld, '|') + " " + CRLF
		EndIf

		If !(Empty(cNoFil))
			cQuery += "	AND AKD.AKD_FILIAL NOT IN" + FormatIn(cNoFil, '|') + " " + CRLF
		EndIf

		cQuery += "	AND AKD.AKD_STATUS = '1' " + CRLF
		cQuery += "	AND AKD.AKD_CO IN" + FormatIn(cContas, '|') + " " + CRLF
		cQuery += "	AND AKD.D_E_L_E_T_ <> '*' " + CRLF
		cQuery += "GROUP BY AKD.AKD_FILIAL " + CRLF
		cQuery += "ORDER BY AKD.AKD_FILIAL " + CRLF

		cTmpAlias := GetNextAlias()

		If Select(cTmpAlias) > 0
			(cTmpAlias)->(DbCloseArea())
		EndIf

		DbUseArea(.T., 'TOPCONN', TCGenQry(,, cQuery), cTmpAlias, .F., .T.)

		While !((cTmpAlias)->(Eof()))
			Aadd(aRet, {(cTmpAlias)->AKD_FILIAL, (cTmpAlias)->VALREAL})

			(cTmpAlias)->(DbSkip())
		EndDo

		If Select(cTmpAlias) > 0
			(cTmpAlias)->(DbCloseArea())
		EndIf
	EndIf
Return aRet

/*/
Retorna o faturamento real por empresa.
/*/
Static Function GetFatReal()
	Local aRet		:= {}
	Local cQuery 	:= ""
	Local cTmpAlias	:= ""
	Local cNoFil	:= GetMv('DD_POFILDE', .F., '')

	cQuery := "SELECT FILIAL " + CRLF
	cQuery += "	,SUM(VALOR_BRUTO) AS VALOR_BRUTO " + CRLF
	cQuery += "FROM ( " + CRLF
	cQuery += "	SELECT 'VENDA' AS ORIGEM " + CRLF
	cQuery += "		,SF2.F2_FILIAL AS FILIAL " + CRLF
	cQuery += "		,SUM(SF2.F2_VALBRUT) AS VALOR_BRUTO " + CRLF
	cQuery += "	FROM " + RetSqlName("SF2") + " SF2 (NOLOCK) " + CRLF
	cQuery += "	WHERE SF2.F2_EMISSAO >= '" + DtoS(MV_PAR01) + "' " + CRLF
	cQuery += "		AND SF2.F2_EMISSAO <= '" + DtoS(MV_PAR02) + "' " + CRLF

	If !(Empty(cNoFil))
		cQuery += "	AND SF2.F2_FILIAL NOT IN" + FormatIn(cNoFil, '|') + " " + CRLF
	EndIf

	cQuery += "		AND SF2.F2_TIPO NOT IN('D', 'B') " + CRLF
	cQuery += "		AND SF2.F2_VEND1 <> ' ' " + CRLF
	cQuery += "		AND SF2.D_E_L_E_T_ <> '*' " + CRLF
	cQuery += "	GROUP BY SF2.F2_FILIAL " + CRLF

	cQuery += "	UNION " + CRLF

	cQuery += "	SELECT 'DEVOLUCAO' AS ORIGEM " + CRLF
	cQuery += "		,SF1.F1_FILIAL AS FILIAL " + CRLF
	cQuery += "		,(SUM(SF1.F1_VALBRUT) * -1) AS VALOR_BRUTO " + CRLF
	cQuery += "	FROM " + RetSqlName("SF1") + " SF1 (NOLOCK) " + CRLF
	cQuery += "	WHERE SF1.F1_EMISSAO >= '" + DtoS(MV_PAR01) + "' " + CRLF
	cQuery += "		AND SF1.F1_EMISSAO <= '" + DtoS(MV_PAR02) + "' " + CRLF

	If !(Empty(cNoFil))
		cQuery += "	AND SF1.F1_FILIAL NOT IN" + FormatIn(cNoFil, '|') + " " + CRLF
	EndIf

	cQuery += "		AND SF1.F1_ORIGLAN = 'LO' " + CRLF
	cQuery += "		AND SF1.D_E_L_E_T_ <> '*' " + CRLF
	cQuery += "	GROUP BY SF1.F1_FILIAL " + CRLF
	cQuery += ") AS VENDAS " + CRLF
	cQuery += "GROUP BY VENDAS.FILIAL " + CRLF
	cQuery += "ORDER BY VENDAS.FILIAL " + CRLF

	cTmpAlias := GetNextAlias()

	If Select(cTmpAlias) > 0
		(cTmpAlias)->(DbCloseArea())
	EndIf

	DbUseArea(.T., 'TOPCONN', TCGenQry(,, cQuery), cTmpAlias, .F., .T.)

	While !((cTmpAlias)->(Eof()))
		Aadd(aRet, {(cTmpAlias)->FILIAL, (cTmpAlias)->VALOR_BRUTO})

		(cTmpAlias)->(DbSkip())
	EndDo

	If Select(cTmpAlias) > 0
		(cTmpAlias)->(DbCloseArea())
	EndIf
Return aRet

/*/
Verifica o grupo de perguntas do relatório.
/*/

Static Function AjustaSX1(cPerg)
	Local aArea	:= GetArea()
	Local aPerg	:= {}
	Local lInc	:= .T.
	Local nX	:= 0
	Local nY	:= 0

	Default cPerg	:= "OrcXreal"

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO+X1_ORDEM

	cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))

	AAdd(aPerg, {cPerg, "01", "Inicio da Apuracao?", "Inicio da Apuracao?", "Inicio da Apuracao?", "MV_CH1", "D", 8, 0, 0,;
				"G", "", "MV_PAR01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",;
				"", "", "", "", "S", "", "", ""})
	AAdd(aPerg, {cPerg, "02", "Fim da Apuracao?", "Fim da Apuracao?", "Fim da Apuracao?", "MV_CH2", "D", 8, 0, 0, "G",;
				"", "MV_PAR02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",;
				"", "", "", "S", "", "", ""})
	AAdd(aPerg, {cPerg, "03", "Orcamento Receita?", "Orcamento Receita?", "Orcamento Receita?", "MV_CH3", "C", TamSX3("AK2_ORCAME")[1],;
				0, 0, "G", "", "MV_PAR03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",;
				"", "", "", "", "", "AK1", "S", "", "", PesqPict("AK2", "AK2_ORCAME")})
	AAdd(aPerg, {cPerg, "04", "Versao OR?", "Versao OR?", "Versao OR?", "MV_CH4", "C", TamSX3("AK2_VERSAO")[1], 0, 0,;
				"G", "NaoVazio()", "MV_PAR04", "", "", "", "", "", "", "", "", "", "", "", "", "", "",;
				"", "", "", "", "", "", "", "", "", "", "", "S", "", "", PesqPict("AK2", "AK2_VERSAO")})
	AAdd(aPerg, {cPerg, "05", "Orcamento Despesa?", "Orcamento Despesa?", "Orcamento Despesa?", "MV_CH5", "C", TamSX3("AK2_ORCAME")[1],;
				0, 0, "G", "", "MV_PAR05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",;
				"", "", "", "", "", "AK1", "S", "", "", PesqPict("AK2", "AK2_ORCAME")})
	AAdd(aPerg, {cPerg, "06", "Versao OD?", "Versao OD?", "Versao OD?", "MV_CH6", "C", TamSX3("AK2_VERSAO")[1], 0, 0,;
				"G", "NaoVazio()", "MV_PAR06", "", "", "", "", "", "", "", "", "", "", "", "", "", "",;
				"", "", "", "", "", "", "", "", "", "", "", "S", "", "", PesqPict("AK2", "AK2_VERSAO")})

	For nX := 1 To Len(aPerg)
		lInc := !(SX1->(DbSeek(cPerg + aPerg[nX,2])))

		RecLock("SX1", lInc)
			For nY := 1 To FCount()
				If nY <= Len(aPerg[nX])
					If nY == 17
						Loop
					EndIf

					FieldPut(nY, aPerg[nX, nY])
				EndIf
			Next nY
		MsUnlock()
	Next nX

	RestArea(aArea)
Return
