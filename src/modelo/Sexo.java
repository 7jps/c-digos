package modelo;

public enum Sexo {
	FEMININO("Feminino"), MASCULINO("Masculino"), OUTROS("Outros");
	
	private String desc;
	
	private Sexo(String d) {
		desc = d;
	}
	public String getDesc() {
		return desc;
	}
}
