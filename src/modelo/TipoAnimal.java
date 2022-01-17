package modelo;

public enum TipoAnimal {
	CACHORRO("Cachorro"), GATO("Gato");
	
private String desc;
	
	private TipoAnimal(String d) {
		desc = d;
	}
	public String getDesc() {
		return desc;
	}
}
