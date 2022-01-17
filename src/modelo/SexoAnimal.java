package modelo;

public enum SexoAnimal {
	
	FEMEA("F�mea"), MACHO("Macho");
	
	private String desc;
	
	private SexoAnimal(String d) {
		desc = d;
	}
	public String getDesc() {
		return desc;
	}
}

