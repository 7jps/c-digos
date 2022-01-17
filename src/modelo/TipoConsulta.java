package modelo;

public enum TipoConsulta {
	
		REVISAO("Revis�o"), CIRURGIA("Cirurgia"), CASTRACAO("Castra��o");
	
	private String desc;

	private TipoConsulta(String d) {
		desc = d;
	}
	public String getDesc() {
		return desc;
	}

}

