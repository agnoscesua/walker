package Helper;

import org.json.JSONArray;
import org.json.JSONObject;

import DB.DBManager;

import java.sql.*;

public class SqlHelper {
	public static JSONArray getStations(){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray stations = new JSONArray();
		conn = DBManager.getConnection();
		try {
			String sql = "select G1.stationid,G1.stationname,G2.x,G2.y from G_STATIONINFO G1 inner join G_STATIONORIENT G2 on G1.stationid=G2.stationid";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("stationid", rs.getString("stationid"));
				jsonObject.put("stationname", rs.getString("stationname"));
				jsonObject.put("lng", rs.getFloat("x"));
				jsonObject.put("lat", rs.getFloat("y"));
				stations.put(jsonObject);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt, rs);
		}
		return stations;
	}
	
	public static JSONArray getLeaseNumById(String id, String from, String to){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray stations = new JSONArray();
		conn = DBManager.getConnection();
		String sql = "select leasedate,sum(bikenum) from (select * from T_123 where leasestation=?) group by leasedate having leasedate>=? and leasedate<=? order by leasedate";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, from);
			pstmt.setString(3, to);
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("leasedate", rs.getString("leasedate"));
				jsonObject.put("leasenum", rs.getString("sum(bikenum)"));
				stations.put(jsonObject);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt, rs);
		}
		return stations;
	}
	
	public static JSONArray getLeaseNumByHour(String id, String leasedate) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray stations = new JSONArray();
		try {
			conn = DBManager.getConnection();
			String sql = "select leasetime,sum(bikenum) from T_123 where leasedate = ? and leasestation = ? group by leasetime order by leasetime";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, leasedate);
			pstmt.setString(2, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("hour", rs.getString("leasetime"));
				jsonObject.put("leasenum", rs.getString("sum(bikenum)"));
				stations.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBManager.close(conn, pstmt, rs);
		}
		return stations;
	}
}
