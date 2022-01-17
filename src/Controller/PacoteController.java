package Controller;

import java.util.Arrays;
import java.util.List;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import dao.Dao;
import modelo.Pacote;
import modelo.TipoPacote;


@ManagedBean
@ViewScoped
public class PacoteController {
	
	private Pacote pacote = new Pacote();

	public Pacote getPacote() {
		return pacote;
	}

	public void setPacote(Pacote pacote) {
		this.pacote = pacote;
	}
	
	public void gravar(Pacote pc){
		if(pc.getId()==null)
			new Dao<Pacote>(Pacote.class).adiciona(pc);
		else
			new Dao<Pacote>(Pacote.class).atualiza(pc);
}
	
	public void remover (Pacote pc){
		new Dao<Pacote>(Pacote.class).remove(pc.getId());
	}
		
		public void carregar(Pacote pc){
			pacote = pc;
		}
		
		public List<Pacote> getTodosPacotes(){
			return new Dao<Pacote>(Pacote.class).buscaTodos();
		}
			
		public List<TipoPacote> getTipoPacotes(){
			return Arrays.asList(TipoPacote.values());
		}		
}

