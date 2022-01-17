package modelo;

public enum TipoPacote {
	
	SEMANAL("Semanal"), QUINZENAL("Quinzenal"), MENSAL("Mensal");
	
private String desc;
	
	private TipoPacote(String d) {
		desc = d;
	}
	public String getDesc() {
		return desc;
	}
}
