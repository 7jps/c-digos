#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FILEIO.CH"
#DEFINE CRLF Chr(13)+Chr(10)


/*/{Protheus.doc} EtiquetaM
ROTINA DESENVOLVIDA PARA IMPRESSÃO DE ETIQUETA MOSTRUÁRIO
@author  João Paulo	
@since   19/06/2019 
@version P12 V1.17
/*/
User Function EtiquetaM(_cDoc,_cSER,_cForn) 

Local cPerg 	:= "ETQMT"
Local cMascara 	:= GetMv("MV_MASCGRD")
Local nTamRef 	:= Val(Substr(cMascara,1,2))
Local nTamLin 	:= Val(Substr(cMascara,4,2))
Local nTamCol 	:= Val(Substr(cMascara,7,2))
Local cCor		:= ""
Local cCodCor	:= ""
Local cProduto	:= "" 
Local aImprimir	:= {}
Default _cDoc   := ""
Default _cSER   := ""
Default _cForn  := ""

CriaSx1(cPerg) 

u_AtPerg("ETQMT", "MV_PAR01", _cDoc) //NF
u_AtPerg("ETQMT", "MV_PAR02", _cSER) //serie
u_AtPerg("ETQMT", "MV_PAR03", _cForn)//fornecedor        	

If Pergunte(cPerg,.T.)
	dbSelectArea('SD1')
	SD1->(dbSetOrder(1))//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	SD1->(dbGoTop())
	
	If SD1->(dbSeek(xFilial('SD1') + MV_PAR01 + MV_PAR02 + MV_PAR03))
		While !SD1->(Eof()) .AND. SD1->(D1_DOC+D1_SERIE+D1_FORNECE) == MV_PAR01 + MV_PAR02 + MV_PAR03
			
			cProduto := SubStr(SD1->D1_COD,1,nTamRef)
			
			dbSelectArea('SB4')
			SB4->(dbSetOrder(1))//B4_FILIAL+B4_COD
			SB4->(dbGoTop())
			
			If SB4->(dbSeek(xFilial('SB4') + cProduto))
				
				dbSelectArea('SBV')
				SBV->(dbSetOrder(1))//BV_FILIAL+BV_TABELA+BV_CHAVE
				SBV->(dbGoTop())
				
				cCodCor := SubStr(SD1->D1_COD,nTamRef+1,nTamLin)
				
				SBV->(dbSeek(xFilial('SBV') + SB4->B4_LINHA + cCodCor))
				
				cCor := cCodCor + ' - '+SBV->BV_DESCRI
				
				AADD(aImprimir,{SubStr(SD1->D1_COD,nTamRef+nTamLin+1,nTamCol),;	//Numero
				cCor,;															//Cor
				SD1->D1_QUANT,;													//Quantidade
				cProduto,;														//Codigo do Produto
				SB4->B4_DESC,;													//Descricao do Produto
				SB4->B4_REF,;													//Referencia 
				SB4->B4_PRV1,;													//Preco de venda
				SD1->D1_PESO,;													//Pc
				SD1->D1_SERIORI})												//Serie
			EndIf
			
			SD1->(dbSkip())
		EndDo
	EndIf
EndIf

If Len(aImprimir) > 0
	ETQMS1(aImprimir)
Else
	MsgBox("Não foram encontradas etiquetas para os parametros informados.","TOTVS","ALERT")
EndIf

Return

//FUNÇÃO PARA CRIAR O ARQUIVO DE ETIQUETAS
Static Function ETQMS1(aImprimir)


Local cCodigoCor	:= ''
Local cEOL    		:= "CHR(13)+CHR(10)"
Local cBuffer 		:= ""
Local cFile			:= "ETIQUETA_NF"
Local cPath			:= "C:\TOTVS\IMPRESSORA\"

cEOL := &cEOL

//Cria diretorio para armazenar os arquivos.
If MAKEDIR(cPath) == 0
	MsgBox("Impossivel criar o diretorio: "+cPath+". Crie manualmente para poder prosseguir","TOTVS","ALERT")
	Return()
EndIf

//Cria o arquivo
nHandle := FCREATE(cPath+cFile+".TXT", NIL,NIL, .F.)

//Verifica se o arquivo foi criado
If FERROR() != 0
	MsgBox("Impossivel gravar o arquivo das etiquetas, Erro : "+Alltrim(Str(FERROR())),"TOTVS","ALERT")
	Return()
EndIf

nCnt := 1

IF MV_PAR04 == 1
	cBuffer += '^@' + cEOL
	
	//Percorre o vetor dos itens a serem impressos para montar o arquivo das etiquetas
	For nZ:=1  To Len(aImprimir)
		For nY := 1 To aImprimir[nZ][3]
			//Primeira coluna
			If nCnt == 1
				
				cBuffer += '.' + cEOL
				cBuffer += '<enter>' + cEOL
				cBuffer += 'N' + cEOL
				cBuffer += 'Q240,24' + cEOL
				cBuffer += 'S6' + cEOL
				cBuffer += 'D15' + cEOL  
				
				cBuffer += 'A23,95,0,2,1,2,N,"ou R$ '+AllTrim(Transform(aImprimir[nZ][7],"@E 999,999,999.99"))+' a vista"' + cEOL //PREÇO CHEIO
				IF (aImprimir[nZ][8]) >= 1
					cBuffer += 'A33,07,0,4,1,3,N,"'+AllTrim(Transform(aImprimir[nZ][8],"@E"))+'x de R$ '+AllTrim(Transform(aImprimir[nZ][7]/(aImprimir[nZ][8]),"@E 999,999,999.99"))+'"' + cEOL //PARCELADO
					cBuffer += 'A253,70,0,2,1,1,N,"SEM JUROS"' + cEOL
				EndIF			   

				cBuffer += 'A23,135,0,2,1,1,N,"'+AllTrim(aImprimir[nZ][5])+'"' + cEOL  //Descrição
				cBuffer += 'A128,182,0,2,1,2,N,"cod: '+AllTrim(aImprimir[nZ][4])+'"'+ cEOL      //cod pai
				cBuffer += 'A323,182,0,2,1,2,R,"'+AllTrim(aImprimir[nZ][9])+'"' + cEOL 	   //cod caixa
				
				If nY == aImprimir[nZ][3] .and. nZ == Len(aImprimir)
					cBuffer += 'P1' + cEOL
					cBuffer += '.' + cEOL
					cBuffer += '<Enter key>' + cEOL
					cBuffer += '^@' + cEOL
				EndIf
				
				nCnt++
				
			//Segunda coluna +430
			ElseIf nCnt == 2 
		   		cBuffer += 'A453,95,0,2,1,2,N,"ou R$ '+AllTrim(Transform(aImprimir[nZ][7],"@E 999,999,999.99"))+' a vista"' + cEOL //PREÇO CHEIO
				IF (aImprimir[nZ][8]) >= 1						
			   		cBuffer += 'A463,07,0,4,1,3,N,"'+AllTrim(Transform(aImprimir[nZ][8],"@E"))+'x de R$ '+AllTrim(Transform(aImprimir[nZ][7]/(aImprimir[nZ][8]),"@E 999,999,999.99"))+'"' + cEOL //PARCELADO
			   		cBuffer += 'A683,70,0,2,1,1,N,"SEM JUROS"' + cEOL 
			 	EndIF 				 	

				cBuffer += 'A453,135,0,2,1,1,N,"'+AllTrim(aImprimir[nZ][5])+'"' + cEOL    //Descrição
				cBuffer += 'A558,182,0,2,1,2,N,"cod: '+AllTrim(aImprimir[nZ][4])+'"' + cEOL    //cod pai
				cBuffer += 'A753,182,0,2,1,2,R,"'+AllTrim(aImprimir[nZ][9])+'"' + cEOL 	  //cod caixa
				
				//Finaliza a linha de etiquetas
				If nY == aImprimir[nZ][3] .and. nZ == Len(aImprimir)
					cBuffer += 'P1' + cEOL
					cBuffer += '.' + cEOL
					cBuffer += '<Enter key>' + cEOL
					cBuffer += '^@' + cEOL
				ELSE
					cBuffer += 'P1' + cEOL
				ENDIF

				nCnt := 1
					
			EndIf
		Next nY
	Next nZ
ELSE
///PARA IMPRESSORA ELTRON
	//Percorre o vetor dos itens a serem impressos para montar o arquivo das etiquetas
	For nZ:=1  To Len(aImprimir)
		For nY := 1 To aImprimir[nZ][3]
			//Primeira coluna
			If nCnt == 1
				cBuffer += '~@' + cEOL
				cBuffer += 'N' + cEOL
				cBuffer += 'FK"FORM1"' + cEOL
				cBuffer += 'FS"FORM1"' + cEOL
				cBuffer += 'D15' + cEOL
				cBuffer += 'ZB' + cEOL
				cBuffer += 'R0,0' + cEOL
				cBuffer += 'S6' + cEOL
				cBuffer += 'A23,95,0,2,1,2,N,"ou R$ '+AllTrim(Transform(aImprimir[nZ][7],"@E 999,999,999.99"))+' a vista"' + cEOL //PREÇO CHEIO
				
				IF (aImprimir[nZ][8]) >= 1
					cBuffer += 'A33,07,0,4,1,3,N,"'+AllTrim(Transform(aImprimir[nZ][8],"@E"))+'x de R$ '+AllTrim(Transform(aImprimir[nZ][7]/(aImprimir[nZ][8]),"@E 999,999,999.99"))+'"' + cEOL //PARCELADO
					cBuffer += 'A253,70,0,2,1,1,N,"SEM JUROS"' + cEOL
				EndIF			   
				
				cBuffer += 'A23,135,0,2,1,1,N,"'+AllTrim(aImprimir[nZ][5])+'"' + cEOL			//Descrição
				cBuffer += 'A128,182,0,2,1,2,N,"cod: '+AllTrim(aImprimir[nZ][4])+'"'+ cEOL      //cod pai
				cBuffer += 'A323,182,0,2,1,2,R,"'+AllTrim(aImprimir[nZ][9])+'"' + cEOL 	   		//cod caixa
				
				//Verifica se é o fim do arquivo para finalizar
				If nY == aImprimir[nZ][3] .and. nZ == Len(aImprimir)
					cBuffer += 'FE' + cEOL
					cBuffer += 'FR"FORM1"' + cEOL
					cBuffer += 'P1' + cEOL
				EndIf
				
				nCnt++
			//Segunda coluna
			ElseIf nCnt == 2
			
		   		cBuffer += 'A453,95,0,2,1,2,N,"ou R$ '+AllTrim(Transform(aImprimir[nZ][7],"@E 999,999,999.99"))+' a vista"' + cEOL //Preço cheio
				IF (aImprimir[nZ][8]) >= 1						
			   		cBuffer += 'A463,07,0,4,1,3,N,"'+AllTrim(Transform(aImprimir[nZ][8],"@E"))+'x de R$ '+AllTrim(Transform(aImprimir[nZ][7]/(aImprimir[nZ][8]),"@E 999,999,999.99"))+'"' + cEOL //PARCELADO
			   		cBuffer += 'A683,70,0,2,1,1,N,"SEM JUROS"' + cEOL 
			 	EndIF 				 	

				cBuffer += 'A453,135,0,2,1,1,N,"'+AllTrim(aImprimir[nZ][5])+'"' + cEOL    //Descrição
				cBuffer += 'A558,182,0,2,1,2,N,"cod: '+AllTrim(aImprimir[nZ][4])+'"' + cEOL    //cod pai
				cBuffer += 'A753,182,0,2,1,2,R,"'+AllTrim(aImprimir[nZ][9])+'"' + cEOL 	  //cod caixa 												//mes ano
				
				//Verifica se e o fim do arquivo para finalizar
				cBuffer += 'FE' + cEOL
				cBuffer += 'FR"FORM1"' + cEOL
				cBuffer += 'P1' + cEOL
				nCnt := 1
			EndIf
		Next nY
	Next nZ
	//*/
ENDIF 
 
 
 
	
If FWRITE(nHandle, cBuffer, Len(cBuffer)) < Len(cBuffer)
	MsgBox("Erro na gravação do Arquivo de Etiquetas - Escrita de Buffer","TOTVS","ALERT")
	Return(nil)
Else

	/*
	**	TRATAMENTO PARA IMPRESSORAS NAO FISCAIS                               
	** 	Segue exemplo de sessao no smartclient.ini:                           
	**	[INF]                                                                
	**	PORTA=USB                                                             
	**	LOCAL=\\COMPUTADOR\BEMATECH4200                                       
	====================================================================
	** A Porta pode ser COM1,COM2...,LPT1,LPT2,... OU USB                    
	** O caminho da impressora compartilhada para caso da porta = USB        
	*/
	
	cIniName:= GetRemoteIniName()
	cTXT := FT_FUse(cININAME)
	cLOCAL 	:= ""
	cPORTA	:= ""
	
	FOR I:=1 TO 60
		cLine  := ALLTRIM(FT_FReadLn())
		IF cLINE == "[INF]"
			FT_FSKIP()
			cLine  := ALLTRIM(FT_FReadLn())
			cPORTA := UPPER(SUBSTR(cLINE,7))			//PORTA=USB OU PORTA=COM?
			FT_FSKIP()
			cLine  := ALLTRIM(FT_FReadLn())
			IF cPORTA == "USB"
				IF UPPER(SUBSTR(cLINE,1,5)) == "LOCAL"
					cLOCAL := SUBSTR(cLINE,7)			//LOCAL=\\COMPUTADOR\BEMATECH4200
				ELSE
					DEFINE MSDIALOG OJANEM TITLE "USB PRECISA DE CAMINHO!!!" FROM ASIZE[7]/3,ASIZE[1]/3 TO ASIZE[6]/3,ASIZE[5]/2 COLORS 0, 16777215 PIXEL
					OSAYM := TSAY():NEW( 020, 010, {|| "Não foi definido o caminho da impressora compartilhada"  },OJANEM,, oFontC2,,,, .T., CLR_BLUE,CLR_WHITE,500,15)
					OSAYM := TSAY():NEW( 030, 010, {|| "no arquivo 'smartclient.ini' na sessão [INF]"  },OJANEM,, oFontC2,,,, .T., CLR_BLUE,CLR_WHITE,500,15)
					OSAYM := TSAY():NEW( 040, 010, {|| "Exemplo: LOCAL=\\NOMEDAMAQUINA\NOMEDAIMPRESSORA"  },OJANEM,, oFontC2,,,, .T., CLR_BLUE,CLR_WHITE,500,15)
					OBUTTON4:=TBUTTON():NEW(050,080,"SAIR",OJANEM,{||OJANEM:END(),OJANEM:END()},040,20,,,,.T.)
					OSAYM:LTRANSPARENT:= .F.
					ACTIVATE MSDIALOG OJANEM CENTERED
					RETURN(NIL)
				ENDIF
			ENDIF
			EXIT
		ELSE
			FT_FSKIP()
		ENDIF
	NEXT
	
	IF ALLTRIM(cPORTA) == "USB" .AND. !EMPTY(cLOCAL)
		ShellExecute("Open", "C:\Windows\System32\cmd.exe", "NET USE LPT1: "+cLOCAL+" /PERSISTENT:YES", cPath, 0)
		cPORTA := "LPT1"
	ENDIF
	FCLOSE(nHandle)
	ShellExecute("Open", "C:\Windows\System32\cmd.exe", "/k copy "+cPath+cFile+".TXT LPT1 ", cPath, 0)
	
ENDIF
Return

//cria pergunta
Static Function CriaSX1(cGrpPerg)

//help da pergunta
Local aHelpPor := {}

//Nota Fiscal?
aHelpPor := {}
AADD(aHelpPor,"Indique o Nota Fiscal       ")
AADD(aHelpPor,"de Entrada a ser utilizado. ")

PutSx1(cGrpPerg,"01","Nota Fiscal?","a","a","MV_CH1","C",TamSX3("D1_DOC")[1],0,0,"G","","SD1","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,{},{},"")

// Documento ate?
aHelpPor := {}
AADD(aHelpPor,"Indique a Série     ")
AADD(aHelpPor,"a ser utilizada.    ")

PutSx1(cGrpPerg,"02","Série?","a","a","MV_CH2","C",TamSX3("D1_SERIE")[1],0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,{},{},"")

// Fornecedor de?
aHelpPor := {}
AADD(aHelpPor,"Indique o fornecedor")
AADD(aHelpPor,"a ser utilizado.    ")

PutSx1(cGrpPerg,"03","Fornecedor?","a","a","MV_CH3","C",TamSX3("A2_COD")[1],0,0,"G","","SA2","","","MV_PAR03","","","","","","","","","","","","","","","","",aHelpPor,{},{},"")

//impressora
aHelpPor := {}
AADD(aHelpPor,"Indique a Impressora") 
AADD(aHelpPor,"a ser utilizada.    ")

PutSx1(cGrpPerg,"04","Impressora?","a","a"				,"MV_CH4","C",10,0,3,"C","","","","","MV_PAR04","ZEBRA","ZEBRA","ZEBRA","","ELTRON"	,"ELTRON"	,"ELTRON"	,"","","","","","","","","",aHelpPor,{},{},"")
Return
