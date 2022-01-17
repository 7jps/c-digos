package Controller;

import java.util.Arrays;
import java.util.List;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import dao.Dao;
import modelo.Consulta;
import modelo.TipoConsulta;

@ManagedBean
@ViewScoped
public class ConsultaController{ 
	private Consulta consulta = new Consulta();
	
	public void gravar() {
        if(consulta.getId() == null)
            new Dao<Consulta>(Consulta.class).adiciona(consulta);
        else
            new Dao<Consulta>(Consulta.class).atualiza(consulta);
    }
	
	public void remover(Consulta c){
        new Dao<Consulta>(Consulta.class).remove(c.getId());
    }
	
	public void carregar(Consulta c) { 
		consulta = c;				
	}

	public Consulta getConsulta() {
		return consulta;
	}

	public void setConsulta(Consulta consulta) {
		this.consulta = consulta;
	}

	public List<Consulta> getTodasConsultas(){
		return new Dao<Consulta>(Consulta.class).buscaTodos(); 
	}
	
	 public List<TipoConsulta> getTipoConsulta(){
			return Arrays.asList(TipoConsulta.values()); 
		}  
	 
}
