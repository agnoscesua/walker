package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;

import Helper.SqlHelper;

@WebServlet("/DatabyHour.html")
public class DatabyHour extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String stationid = request.getParameter("stationid");
		String time = request.getParameter("time");
		JSONArray leaseHour = SqlHelper.getLeaseNumByHour(stationid, time);
		response.getWriter().write(leaseHour + "@wujiu@");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
