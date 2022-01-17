//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
    
//Constantes
#Define STR_PULA        Chr(13)+Chr(10)

/*/{Protheus.doc} PEDIDO
Relatorio Pedido de Compras dinâmico
@author  João Paulo	
@since   20/03/2020 
@version P12 V1.17
/*/
User Function PEDIDO()
    Local aArea   := GetArea()
    Local oReport
    Local lEmail  := .F.
    Local cPara   := ""

    Private cPerg := "XREL6" 
    Pergunte (cPerg, .F.)

    //Cria as definições do relatório
    oReport := fReportDef()
    

    //Será enviado por e-Mail?
    If lEmail
        oReport:nRemoteType := NO_REMOTE
        oReport:cEmail := cPara
        oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
        oReport:SetPreview(.F.)
        oReport:Print(.F., "", .T.)
    //Senão, mostra a tela
    Else
        oReport:PrintDialog()
    EndIf
    
    RestArea(aArea)
Return
    
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/
    
Static Function fReportDef()
    Local oReport
    Local oSectDad  := Nil 
    Local oSectDad2 := Nil 
    Local oSectDad3 := Nil 
    Local oBreak    := Nil 
    Local cTitulo	:= "PEDIDOS_DONDERI_"+SUBSTR(TIME(), 4, 2)+SUBSTR(TIME(), 7, 2)   
    
    Private	aMarcas 	:= {}
    Private	aCole 		:= {}  
    Private	aFiliais 	:= {}
    
    //Criando do componente de impressão
    oReport := TReport():New(cTitulo  ,;        //Nome do Relatório
                             "Relatorio",;        //Título
                             cPerg,;        //Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
                             {|oReport|; //Bloco de código que será executado na confirmação da impressão
                             		aMarcas := IIF( MV_PAR01 == 2 ,U_DDChekMarc(),{}),;
                             		aCole := IIF( MV_PAR02 == 2 , U_DDChekCole(),{}),; 
                             		aFiliais := IIF( MV_PAR03 == 2 , U_DDChekFIL(),{}),;
                             		fRepPrint(oReport)},;       
                                )        //Descrição
    oReport:SetTotalInLine(.F.)
    oReport:lParamPage := .F.
    oReport:oPage:SetPaperSize(9) //Folha A4
    oReport:SetPortrait()
	    
    //Criando a seção de dados 1
    oSectDad := TRSection():New(    oReport,;        //Objeto TReport que a seção pertence
                                    "EMPRESA X COLECAO X MARCA",;        //Descrição da seção
                                    {"QRY_AUX"})        //Tabelas utilizadas, a primeira será considerada como principal da seção
    oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha  
    
    //Criando a seção de dados 2
    oSectDad2 := TRSection():New(    oReport,;        //Objeto TReport que a seção pertence
                                    "LOJA X COLECAO X MARCA",;        //Descrição da seção
                                    {"QRY_AUX2"})        //Tabelas utilizadas, a primeira será considerada como principal da seção
    oSectDad2:SetTotalInLine(.F.)  //Define se os totalizadores ser?o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
   
	
	//Criando a seção de dados 3
	oSectDad3 := TRSection():New(    oReport,;        //Objeto TReport que a seção pertence
                                    "PEDIDOS ATRASADOS",;        //Descrição da seção
                                    {"QRY_AUX3"})        //Tabelas utilizadas, a primeira será considerada como principal da seção
    oSectDad3:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha     
  
  
//Colunas do relatório 1
   	TRCell():New(oSectDad, "B4_01COLEC", "QRY_AUX", "COD", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)    
	TRCell():New(oSectDad, "AYH_DESCRI", "QRY_AUX", "COLECAO", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)       	
	TRCell():New(oSectDad, "VALORT", "QRY_AUX", "VALOR TOTAL","@E 999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)   	
	TRCell():New(oSectDad, "TOTAL", "QRY_AUX", "Qtd Tot", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)   
	TRCell():New(oSectDad, "VALORE", "QRY_AUX", "VALOR ENTREGUE","@E 999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)   		
	TRCell():New(oSectDad, "ENTREGUE", "QRY_AUX", "Qtd Ent", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALORA", "QRY_AUX", "VALOR ABERTO","@E 999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)   	
	TRCell():New(oSectDad, "ABERTO", "QRY_AUX", "Qtd Aber.", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALORAT", "QRY_AUX", "VALOR ATRASO","@E 999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)   	
 	TRCell():New(oSectDad, "ATRASO", "QRY_AUX", "Qtd ATRASO", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)   
 	TRCell():New(oSectDad, "AY2_DESCR", "QRY_AUX", "MARCA", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)     

//Colunas do relatório 2
	TRCell():New(oSectDad2, "AYM_FILDES", "QRY_AUX2", "FILIAL", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "VALORT", "QRY_AUX2", "VALOR TOTAL","@E 999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)   	
	TRCell():New(oSectDad2, "TOTAL", "QRY_AUX2", "Qtd Tot",/*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)   
	TRCell():New(oSectDad2, "VALORE", "QRY_AUX2", "VALOR ENTREGUE","@E 999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)   		
	TRCell():New(oSectDad2, "ENTREGUE", "QRY_AUX2", "Qtd Ent.", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "VALORA", "QRY_AUX2", "VALOR ABERTO","@E 999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)   	
	TRCell():New(oSectDad2, "ABERTO", "QRY_AUX2", "Qtd Aber.", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "AYH_DESCRI", "QRY_AUX2", "COLECAO", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)       	   
 	TRCell():New(oSectDad2, "AY2_DESCR", "QRY_AUX2", "MARCA", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)         

//Definindo a quebra Seção 1
    oBreak := TRBreak():New(oSectDad,{|| QRY_AUX->AYH_DESCRI},{|| "" })
    oSectDad:SetHeaderBreak(.T.)     
    
//Definindo a quebra Seção 2
    oBreak2 := TRBreak():New(oSectDad2,{|| QRY_AUX2->AYM_FILDES + QRY_AUX2->AYH_DESCRI},{|| "" })
    oSectDad2:SetHeaderBreak(.T.)   
	
//Totalizadores Seção 1
    oFunTot7 := TRFunction():New(oSectDad:Cell("VALORT"),,"SUM",oBreak,,"@E 999,999,999,999.99")
    oFunTot7:SetEndReport(.F.) 
    oFunTot8 := TRFunction():New(oSectDad:Cell("TOTAL"),,"SUM",oBreak,,)
	oFunTot8 :SetEndReport(.F.)   
	oFunTotA := TRFunction():New(oSectDad:Cell("VALORE"),,"SUM",oBreak,,"@E 999,999,999,999.99")
    oFunTotA :SetEndReport(.F.) 
    oFunTotB := TRFunction():New(oSectDad:Cell("ENTREGUE"),,"SUM",oBreak,,)
	oFunTotB :SetEndReport(.F.)   
	oFunTotC := TRFunction():New(oSectDad:Cell("VALORA"),,"SUM",oBreak,,"@E 999,999,999,999.99")
	oFunTotC :SetEndReport(.F.) 
	oFunTotD := TRFunction():New(oSectDad:Cell("ABERTO"),,"SUM",oBreak,,)
	oFunTotD:SetEndReport(.F.) 
	oFunTotE := TRFunction():New(oSectDad:Cell("VALORAT"),,"SUM",oBreak,,"@E 999,999,999,999.99")
	oFunTotE :SetEndReport(.F.) 
	oFunTotF := TRFunction():New(oSectDad:Cell("ATRASO"),,"SUM",oBreak,,)
	oFunTotF:SetEndReport(.F.)   
	
//Totalizadores Seção 2
    oFunTot1 := TRFunction():New(oSectDad2:Cell("VALORT"),,"SUM",oBreak2,,"@E 999,999,999,999.99")
    oFunTot1 :SetEndReport(.F.) 
    oFunTot2 := TRFunction():New(oSectDad2:Cell("TOTAL"),,"SUM",oBreak2,,)
	oFunTot2 :SetEndReport(.F.)   
	oFunTot3 := TRFunction():New(oSectDad2:Cell("VALORE"),,"SUM",oBreak2,,"@E 999,999,999,999.99")
    oFunTot3 :SetEndReport(.F.) 
    oFunTot4 := TRFunction():New(oSectDad2:Cell("ENTREGUE"),,"SUM",oBreak2,,)
	oFunTot4 :SetEndReport(.F.)   
	oFunTot5 := TRFunction():New(oSectDad2:Cell("VALORA"),,"SUM",oBreak2,,"@E 999,999,999,999.99")
	oFunTot5 :SetEndReport(.F.) 
	oFunTot6 := TRFunction():New(oSectDad2:Cell("ABERTO"),,"SUM",oBreak2,,)
	oFunTot6 :SetEndReport(.F.) 

	IF(MV_PAR08 == 1)
//Colunas do relatório 3
	TRCell():New(oSectDad3, "C7_NUM", "QRY_AUX3", "PEDIDO", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad3, "A2_NREDUZ", "QRY_AUX3", "FORNECEDOR",/*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)  	
 	TRCell():New(oSectDad3, "C7_DATPRF", "QRY_AUX3", "DATA",/*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,"CENTER",/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)   
	TRCell():New(oSectDad3, "QTDT", "QRY_AUX3", "Qtd Total",/*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)  
	TRCell():New(oSectDad3, "QTDE", "QRY_AUX3", "Qtd Entregue",/*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)  
	TRCell():New(oSectDad3, "ATRASO", "QRY_AUX3", "ATRASO",/*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)  

//Definindo a quebra Seção 3 
    oBreak3 := TRBreak():New(oSectDad3,{|| QRY_AUX3->A2_NREDUZ},{|| "" })
    oSectDad3:SetHeaderBreak(.T.) 	

//Totalizadores Seção 3
    oFunTotG := TRFunction():New(oSectDad3:Cell("QTDT"),,"SUM",oBreak3,,)
	oFunTotG :SetEndReport(.F.) 
	oFunTotH := TRFunction():New(oSectDad3:Cell("QTDE"),,"SUM",oBreak3,,)
	oFunTotH :SetEndReport(.F.)
	oFunTotI := TRFunction():New(oSectDad3:Cell("ATRASO"),,"SUM",oBreak3,,)
	oFunTotI :SetEndReport(.F.)     
	EndIf	

Return oReport
    
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
    
Static Function fRepPrint(oReport)
    Local aArea    := GetArea()
    Local cQryAux  := ""  
    Local cQryAux2 := ""
    Local cQryAux3 := ""
    
    Local oSectDad := Nil    
    Local oSectDad2 := Nil  
    Local oSectDad3 := Nil
    
    Local nAtual   := 0
    Local nTotal   := 0
  
    Local cMarcas := ""
    Local cCol 	  := ""
    Local cFil 	  := "" 
    
    Local upar4
    Local upar5
    Local upar8	  := MV_PAR08
    Local cDate	  := DToS(Date())

    //Padronização dos Arrays com Itens selecionados para funcionamento de query
    AEval( aMarcas, { | aMarcas | cMarcas += aMarcas + "," } ) 

    AEval( aCole, { | aCole | cCol += aCole + "," } )
    
    AEval( aFiliais, { | aFiliais | cFil += "01"+aFiliais +"," } ) 

//Pegando as seções do relatório
    oSectDad := oReport:Section(1) 
    
    //Montando consulta de dados
	cQryAux := ""	
	cQryAux += "SELECT B4_01COLEC, AYH_DESCRI, AY2_DESCR,  "															+ STR_PULA
	cQryAux += "	SUM(C7_TOTAL) AS VALORT, SUM(C7_QUANT) AS TOTAL,			 " 										+ STR_PULA//TOTAL 
	cQryAux += "	SUM(C7_PRECO * C7_QUJE) AS VALORE,  SUM(C7_QUJE) AS ENTREGUE, "    									+ STR_PULA//ENTREGUE
	cQryAux += "	SUM((C7_PRECO * C7_QUANT)-(C7_PRECO * C7_QUJE)) AS VALORA, SUM(C7_QUANT - C7_QUJE) AS ABERTO,	 " 	+ STR_PULA//ABERTO
	cQryAux += "	SUM(CASE WHEN (C7_DATPRF < '"+(cDate)+"') THEN C7_QUANT - C7_QUJE END) AS ATRASO,			"  		+ STR_PULA//ATRASO
	cQryAux += "	SUM(CASE WHEN (C7_DATPRF < '"+(cDate)+"') THEN (C7_QUANT - C7_QUJE) * C7_PRECO END) AS VALORAT,"	+ STR_PULA//ATRASO
	cQryAux += "	MIN(C7_NUM) AS PedIni, MAX(C7_NUM) AS PedFim 		" 												+ STR_PULA
	cQryAux += "FROM	SC7010 		"   																				+ STR_PULA
	cQryAux += "	INNER JOIN SB1010 ON C7_PRODUTO = B1_COD 			"   			   						   		+ STR_PULA    
	cQryAux += "	INNER JOIN SB4010 ON B1_01PRODP = B4_COD 			"   											+ STR_PULA
	cQryAux += "	INNER JOIN AYH010 ON B4_01COLEC = AYH_CODIGO        "   											+ STR_PULA
	cQryAux += "	INNER JOIN AY2010 ON B4_01CODMA = AY2_CODIGO        "   											+ STR_PULA    
	cQryAux += "WHERE  (C7_NUM >= '"+(MV_PAR04)+"') AND (C7_NUM <= '"+(MV_PAR05)+"') AND (SC7010.D_E_L_E_T_ = ' ') " 	+ STR_PULA
	cQryAux += "	AND (C7_DATPRF >= '"+DToS(MV_PAR06)+"') AND (C7_DATPRF <= '"+DToS(MV_PAR07)+"')		 "			 	+ STR_PULA//DATA ENTREGA
	cQryAux += "	AND (AYH010.D_E_L_E_T_ = ' ') AND (AY2010.D_E_L_E_T_ = ' ')  "     									+ STR_PULA
	cQryAux += "	AND (SB4010.D_E_L_E_T_ = ' ') AND (SB1010.D_E_L_E_T_ = ' ')"       									+ STR_PULA
	If !(Empty(cMarcas))
 		cQryAux += "	AND AY2_CODIGO IN" + FormatIn(cMarcas,',') + " " 												+ STR_PULA
 	EndIf
    If !(Empty(cCol))
 		cQryAux += "	AND AYH_CODIGO IN" + FormatIn(cCol,',') + " " 													+ STR_PULA
 	EndIf
	cQryAux += "GROUP BY B4_01COLEC,AYH_DESCRI,AY2_DESCR ORDER BY B4_01COLEC	 "							   			+ STR_PULA
	cQryAux := ChangeQuery(cQryAux)
	    
    //Executando consulta e setando o total da régua
    TCQuery cQryAux New Alias "QRY_AUX"
    Count to nTotal
    oReport:SetMeter(nTotal)
    TCSetField("QRY_AUX", "C7_NUM", "C")
    
    
    oSectDad:Init()
    QRY_AUX->(DbGoTop()) 
    
    upar4 := QRY_AUX->PedIni
    upar5 := QRY_AUX->PedFim
    
	//Enquanto houver dados
    While ! QRY_AUX->(Eof())
    	If(upar4 > QRY_AUX->PedIni)
    		upar4 := QRY_AUX->PedIni
    	Endif
    	If(upar5 < QRY_AUX->PedFim)
    		upar5 := QRY_AUX->PedFim
    	Endif
    	
        //Incrementando a régua
        nAtual++
        oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
        oReport:IncMeter()
        
        //Imprimindo a linha atual
        oSectDad:PrintLine()
        
        QRY_AUX->(DbSkip())
    EndDo
    oSectDad:Finish()
    QRY_AUX->(DbCloseArea())  
 	
//Pegando as seções do relatório 2
    oSectDad2 := oReport:Section(2) 
    
    //Montando consulta de dados 
	cQryAux2 := ""	
	cQryAux2 += "SELECT AYM_FILDES, AYH_DESCRI, AY2_DESCR, SUM(AYM_TOTAL) AS VALORT, SUM(AYM_QUANT) AS TOTAL,			 " 		+ STR_PULA//TOTAL 
	cQryAux2 += "	SUM((AYM_TOTAL / AYM_QUANT) * AYM_QUJE) AS VALORE,  SUM(AYM_QUJE) AS ENTREGUE,                       "      + STR_PULA//ENTREGUE
    cQryAux2 += "	SUM(AYM_TOTAL -((AYM_TOTAL / AYM_QUANT) * AYM_QUJE)) AS VALORA, SUM(AYM_QUANT - AYM_QUJE) AS ABERTO	 "  	+ STR_PULA//ABERTO
	cQryAux2 += "FROM	AYM010 																"   								+ STR_PULA
	cQryAux2 += "	INNER JOIN SB4010 ON AYM_PRODP = B4_COD 			"   						   							+ STR_PULA
    cQryAux2 += "	INNER JOIN AYH010 ON B4_01COLEC = AYH_CODIGO        "   													+ STR_PULA
    cQryAux2 += "	INNER JOIN AY2010 ON B4_01CODMA = AY2_CODIGO        "   						   							+ STR_PULA      
    cQryAux2 += "WHERE  (AYM_NUM >= '"+(upar4)+"') AND (AYM_NUM <= '"+(upar5)+"') AND (AYM010.D_E_L_E_T_ = ' ') "	   	   		+ STR_PULA
    cQryAux2 += "	AND (AYH010.D_E_L_E_T_ = ' ') AND (AY2010.D_E_L_E_T_ = ' ') AND (SB4010.D_E_L_E_T_ = ' ')   "     			+ STR_PULA 
    If !(Empty(cMarcas))
 		cQryAux2 += "	AND AY2_CODIGO IN" + FormatIn(cMarcas,',') + " " 														+ STR_PULA
 	EndIf
    If !(Empty(cCol))
 		cQryAux2 += "	AND AYH_CODIGO IN" + FormatIn(cCol,',') + " " 															+ STR_PULA
 	EndIf
    If !(Empty(cFil))
 		cQryAux2 += "	AND AYM_FILDES IN" + FormatIn(cFil,',') + " " 															+ STR_PULA
 	EndIf	
    cQryAux2 += "GROUP BY AYM_FILDES,AYH_DESCRI,AY2_DESCR ORDER BY AYM_FILDES,AYH_DESCRI,AY2_DESCR "							+ STR_PULA
    cQryAux2 := ChangeQuery(cQryAux2)  
    
	//Executando consulta e setando o total da régua
    TCQuery cQryAux2 New Alias "QRY_AUX2"
    Count to nTotal
    oReport:SetMeter(nTotal)
    TCSetField("QRY_AUX2", "AYM_FILDES", "C")
    
    nAtual := 0
    //Enquanto houver dados
    oSectDad2:Init()
    QRY_AUX2->(DbGoTop())
    While ! QRY_AUX2->(Eof())
        //Incrementando a régua
        nAtual++
        oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
        oReport:IncMeter()
        
        //Imprimindo a linha atual
        oSectDad2:PrintLine()
        
        QRY_AUX2->(DbSkip())
    EndDo  
	
    oSectDad2:Finish() 
    
    QRY_AUX2->(DbCloseArea()) 
     
IF(upar8 == 1)    
//Pegando as seções do relatório 3
    oSectDad3 := oReport:Section(3) 
       
    //Montando consulta de dados 
    cQryAux3 := ""	
	cQryAux3 += "SELECT C7_NUM, A2_NREDUZ, C7_DATPRF ,SUM(C7_QUANT) AS QTDT,SUM(C7_QUJE) AS QTDE, 		 " 	  	 		+ STR_PULA
	cQryAux3 += "							SUM(C7_QUANT - C7_QUJE) AS ATRASO					 		 " 	  	 		+ STR_PULA				
	cQryAux3 += "FROM	SC7010 		"   																				+ STR_PULA
	cQryAux3 += "	INNER JOIN SA2010 ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA				"    					+ STR_PULA
	cQryAux3 += "	INNER JOIN SB1010 ON C7_PRODUTO = B1_COD 			"   			   						   		+ STR_PULA    
	cQryAux3 += "	INNER JOIN SB4010 ON B1_01PRODP = B4_COD 			"   											+ STR_PULA
	cQryAux3 += "	INNER JOIN AYH010 ON B4_01COLEC = AYH_CODIGO        "   											+ STR_PULA	
	cQryAux3 += "WHERE  (C7_NUM  >= '"+(upar4)+"') AND (C7_NUM  <= '"+(upar5)+"') AND (C7_QUANT > C7_QUJE)	  "			+ STR_PULA
	cQryAux3 += "	AND (C7_DATPRF >= '"+DToS(MV_PAR06)+"') AND (C7_DATPRF < '"+(cDate)+"') 		   			" 		+ STR_PULA//DATA BASE
	cQryAux3 += "	AND (SC7010.D_E_L_E_T_ = ' ') AND (SA2010.D_E_L_E_T_ = ' ')   " 									+ STR_PULA
    If !(Empty(cCol))
 		cQryAux3 += "	AND AYH_CODIGO IN" + FormatIn(cCol,',') + " " 													+ STR_PULA
 	EndIf 	
	cQryAux3 += "Group by C7_NUM,A2_NREDUZ,C7_DATPRF order by A2_NREDUZ   				" 								+ STR_PULA	    
	cQryAux3 := ChangeQuery(cQryAux3) 
    
	//Executando consulta e setando o total da régua
    TCQuery cQryAux3 New Alias "QRY_AUX3"
    Count to nTotal
    oReport:SetMeter(nTotal)
    TCSetField("QRY_AUX3", "C7_DATPRF", "D")
    
    nAtual := 0
    //Enquanto houver dados
    oSectDad3:Init()
    QRY_AUX3->(DbGoTop())
    While ! QRY_AUX3->(Eof())
        //Incrementando a régua
        nAtual++
        oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
        oReport:IncMeter()
        
        //Imprimindo a linha atual
        oSectDad3:PrintLine()
        
        QRY_AUX3->(DbSkip())
    EndDo  

    oSectDad3:Finish() 
    
    QRY_AUX3->(DbCloseArea())
ENDIF   
        
    RestArea(aArea)
Return
