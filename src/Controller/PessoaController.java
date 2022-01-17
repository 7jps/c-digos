package Controller;

import java.util.Arrays;
import java.util.List;
import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.ValidatorException;
import dao.Dao;
import modelo.Pessoa;
import modelo.Sexo;


public class PessoaController {

	public void gravar(Pessoa p){ 
		if(p.getId() == null)
			new Dao<Pessoa>(Pessoa.class).adiciona(p); 
		else
			new Dao<Pessoa>(Pessoa.class).atualiza(p);
	}
	
	 public List<Sexo> getSexos(){
			return Arrays.asList(Sexo.values()); 
		}  
	
	 public void ehEmail(FacesContext fc, UIComponent component, Object value) 
	 throws ValidatorException{
		 String email = value.toString();
		 if (!email.contains("@")){
			 throw new ValidatorException(new FacesMessage("E-mail inválido!"));
		 }
	 }
	 
}
