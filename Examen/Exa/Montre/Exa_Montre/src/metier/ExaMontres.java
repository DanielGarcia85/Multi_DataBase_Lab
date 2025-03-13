package metier;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ExaMontres {
    public ExaMontres() {
        accederALaBaseOracle();
    }

    private static final String URL_ORACLE = "jdbc:oracle:thin:@localhost:1521:xe";
    public static Connection oracle = null;
    static {
        try {
            oracle = DriverManager.getConnection(URL_ORACLE, "system", "194548");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    private void accederALaBaseOracle() {
        try {
            oracle.createStatement().execute("INSERT INTO vw_exa_livraison VALUES('19.01.2022', 'Cartier', 'Secret', 20)");
            oracle.createStatement().execute("INSERT INTO vw_exa_livraison VALUES('19.01.2022', 'Flick', 'Flack', 2)");
            oracle.createStatement().execute("INSERT INTO vw_exa_livraison VALUES('11.11.2023', 'Flick', 'Flack', 2)");
            oracle.createStatement().execute("INSERT INTO vw_exa_livraison VALUES('11.11.2023', 'Rolex', 'Daytona', 20)");
            oracle.createStatement().execute("INSERT INTO exa_vente VALUES(NULL, 3, '19.01.2025', 'ChSt', 750)");
        } catch (SQLException e) {
            System.out.println("Erreur lors de la connexion à la base Oracle " + e.getErrorCode());
            switch (e.getErrorCode()){
                case 20001 : System.out.println("Erreur : " + e.getMessage()); break;
                case 20002 : System.out.println("Erreur : " + e.getMessage()); break;
            }
        }
    }
}
