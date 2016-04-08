package DB;

import java.io.IOException;
import java.sql.*;

public class DBManager {

	private static final String URL = "jdbc:oracle:thin:@127.0.0.1:1521:ORCL";
	private static final String USER = "scott";
	private static final String PASSWORD = "tiger";
	
	/**
	 * ��ȡ��oracle���ݿ������
	 */
	public static Connection getConnection(){
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(URL, USER, PASSWORD);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return conn;
	}
	
	/**
	 * �ر����ݿ�����
	 * 
	 * @param conn
	 */
	public static void close(Connection conn){
		if(conn != null){
			try {
				conn.close();
				conn = null;
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * �ر�PreparedStatement
	 * 
	 * @param pstmt
	 */
	public static void close(PreparedStatement pstmt){
		if(pstmt != null){
			try {
				pstmt.close();
				pstmt = null;
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * �ر�ResultSet
	 * 
	 * @param rs
	 */
	public static void close(ResultSet rs){
		if(rs != null){
			try {
				rs.close();
				rs = null;
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * �ر�Connection��PreparedStatement��ResultSet
	 * 
	 * @param conn
	 * @param pstmt
	 * @param rs
	 */
	public static void close(Connection conn, PreparedStatement pstmt,
			ResultSet rs) {

		close(conn);
		close(pstmt);
		close(rs);

	}
}
