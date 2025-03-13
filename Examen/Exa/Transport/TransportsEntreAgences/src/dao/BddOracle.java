package dao;

import java.sql.*;

public class BddOracle {
    public static Connection connection;
    public BddOracle() {try {
        connection=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:" + "XE", "system", "194548");}
    catch(SQLException e){e.printStackTrace();}}
    public ResultSet query(String rqt) throws SQLException { return connection.createStatement().executeQuery(rqt); }
}