package dao;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

import modelo.OrdemServico;

public class OrdemDao {
	public OrdemServico listaPorId(OrdemServico o) {
		EntityManager em = JPAUtil.getEntityManager();
		
		String jpql = "SELECT DISTINCT o FROM OrdemServico o LEFT JOIN FETCH o.itens WHERE o.id = :pId";
		
		TypedQuery<OrdemServico> query = em.createQuery(jpql, OrdemServico.class);
		query.setParameter("pId", o.getId());
		
		o = query.getSingleResult();
		
		em.close();
		
		return o;
	}
}
