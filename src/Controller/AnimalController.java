package Controller;

import java.util.Arrays;
import java.util.List;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import dao.Dao;
import modelo.Animal;
import modelo.SexoAnimal;
import modelo.TipoAnimal;

@ManagedBean
@ViewScoped
public class AnimalController{ 
	private Animal animal = new Animal();
	
	public void gravar() {
        if(animal.getId() == null)
            new Dao<Animal>(Animal.class).adiciona(animal);
        else
            new Dao<Animal>(Animal.class).atualiza(animal);
    }
	
	public void remover(Animal a){
        new Dao<Animal>(Animal.class).remove(a.getId());
    }
	
	public void carregar(Animal a) { 
		animal = a;				
	}

	public Animal getanimal() {
		return animal;
	}

	public void setAnimal(Animal animal) {
		this.animal = animal;
	}

	public List<Animal> getTodosAnimais(){
		return new Dao<Animal>(Animal.class).buscaTodos(); 
	}
	
	 public List<SexoAnimal> getSexoAnimal(){
			return Arrays.asList(SexoAnimal.values()); 
		}  
	 
	 public List<TipoAnimal> getTipoAnimal(){
			return Arrays.asList(TipoAnimal.values()); 
		}  
}