package dao;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

import modelo.Funcionario;
import util.Utils;

public class FuncionarioDao {
	
	public Funcionario buscarPorEmailESenha(String email, String senha) {
		Funcionario usuario;
		
		String jpql = "SELECT DISTINCT f FROM Funcionario f "
				+ "WHERE f.email = :pEmail AND f.senha = :pSenha";
				
		EntityManager em = JPAUtil.getEntityManager();
		TypedQuery<Funcionario> query = em.createQuery(jpql, Funcionario.class);
		query.setParameter("pEmail", email);
		query.setParameter("pSenha", senha);
		
		try {
			usuario = query.getSingleResult();
	    } catch (NoResultException ex) {
	        usuario = null;
	    }
		
		em.close();
		
		return usuario;
	}
	
//	public static void main(String[] args) {
//		Funcionario f = new FuncionarioDao().buscarPorEmailESenha("aline.valle", "123");
//		System.out.println(f.getNome() + ": " + f.getLogin() + ", " + f.getSenha());
//		System.out.println(f.getGrupo().getNome());
//		for (Funcionalidade fu : f.getGrupo().getFuncionalidades()) {
//			System.out.println(fu.getNome() + ", " + fu.getPagina());
//		}
//	}
}
