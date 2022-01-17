package Controller;

import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import dao.FuncionarioDao;
import modelo.Funcionario;

@ManagedBean
@ViewScoped
public class LoginController {
	
	private Funcionario usuario = new Funcionario();

	public Funcionario getUsuario() {
		return usuario;
	}

	public void setUsuario(Funcionario usuario) {
		this.usuario = usuario;
	}
	
	public String logar(){
		Funcionario f = new FuncionarioDao().buscarPorEmailESenha
				(usuario.getEmail(), usuario.getSenha());
		
		FacesContext contexto = FacesContext.getCurrentInstance();
		
		if(f != null){
			contexto.getExternalContext().getSessionMap().put("usuarioLogado", f);
			return "principal?faces-redirect=true";
			
		} else {
			contexto.getExternalContext().getFlash().setKeepMessages(true);
			contexto.addMessage(null, new FacesMessage("E-mail e/ou senha incorretos."));
			
				return "login?faces-redirect=true";
		}
			
	}
	
	public String deslogar(){
		
		FacesContext contexto = 
				FacesContext.getCurrentInstance();
		
		Funcionario f = (Funcionario) contexto.getExternalContext().getSessionMap().get("usuarioLogado");
				contexto.getExternalContext().getSessionMap().remove("usuarioLogado");
			return "login?faces-redirect=true";
	}
	
	public boolean temAcesso(String s){
			return true;
	}
		

}
