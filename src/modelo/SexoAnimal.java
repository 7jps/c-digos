package modelo;

public enum SexoAnimal {
	
	FEMEA("Fêmea"), MACHO("Macho");
	
	private String desc;
	
	private SexoAnimal(String d) {
		desc = d;
	}
	public String getDesc() {
		return desc;
	}
}

