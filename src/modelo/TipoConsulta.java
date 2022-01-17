package modelo;

public enum TipoConsulta {
	
		REVISAO("Revisão"), CIRURGIA("Cirurgia"), CASTRACAO("Castração");
	
	private String desc;

	private TipoConsulta(String d) {
		desc = d;
	}
	public String getDesc() {
		return desc;
	}

}

