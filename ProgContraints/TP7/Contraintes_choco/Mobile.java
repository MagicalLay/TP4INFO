import static choco.Choco.*;
import choco.cp.model.CPModel;
import choco.cp.solver.CPSolver;
import choco.kernel.model.variables.integer.IntegerVariable;

public class Mobile {
	//longueurs
	private int l1, l2, l3, l4;
	//dernières valeurs trouvées pour les masses
	private int m1, m2, m3;
	//masse maximum disponible
	private int masse_max;

	// variables des contraintes sur les longueurs
	private CPModel myModelL;
	private CPSolver mySolverL;
	//... A completer
	private boolean coherent;//vrai si les longueurs sont cohérentes

	// variables des contraintes sur les masses
	private CPModel myModelM;
	private CPSolver mySolverM;
	//... A completer
	private boolean equilibre;

	// constructeur : _lx : longeur de la branche x, m_max : masse maximum disponible
	public Mobile(int _l1, int _l2, int _l3, int _l4, int m_max) {
		//... A completer
		coherent = false;
		equilibre = false;
		poseProblemeLongeur();
		poseProblemeMasse();
	}

	public boolean estEquilibre() {
		return equilibre;
	}

	// accesseurs
	public int getL1() {
		return l1;
	}

	public int getL2() {
		return l2;
	}

	public int getL3() {
		return l3;
	}

	public int getL4() {
		return l4;
	}

	public int getM1() {
		return m1;
	}

	public int getM2() {
		return m2;
	}

	public int getM3() {
		return m3;
	}

	// pose le problème des longeurs (sans le résoudre),
	// Les longueurs sont cohérentes si le mobile est libre
	// (remarque : un peu artificiel car faisable en java 
	// sans contraintes !)
	private void poseProblemeLongeur() {
		//... A completer
	}

	// vérifie la coherence des longueurs
	public boolean longueursCoherentes() {
		//... A completer
		return false;
	}

	// pose le problème des masses (sans le résoudre)
	private void poseProblemeMasse() {
		// A completer
	}

	// résoud le problème des masses
	// la résolution n'est lancée que si l'encombrement est cohérent
	public boolean equilibre() {
		//... A completer
		return false;
	}

	// cherche une autre solution pour les masses
	// la recherche d'une autre solution ne doit être lancée que si le mobile est équilibré
	public boolean autreSolutionMasse() {
		//... A completer
			return false;
	}

	//gestion de l'affichage
	public String toString() {
		String res = "l1 = " + l1 + "\n l2 = " + l2 + "\n l3 = " + l3
				+ "\n l4 = " + l4;
		if (equilibre) {
			res += "\n m1 = " + m1 + "\n m2 = " + m2 + "\n m3 = " + m3;
		} else {
			res += "\n masses pas encore trouvees ou impossibles !";
		}
		return res;
	}

	//tests
	public static void main(String[] args) {
		Mobile m = new Mobile(1, 3, 2, 1, 20);
		//tester avec (1,1,2,3,20),(1,3,1,1,20),(1,3,2,1,20)
		System.out.println(m);
		if (m.longueursCoherentes()) {
			System.out.println("Encombrement OK");
			m.equilibre();
			System.out.println(m);
			while (m.autreSolutionMasse()) {
				System.out.println("OU");
				System.out.println(m);
			}
		} else {
			System.out.println("Encombrement pas coherent !");
		}
	}
}
