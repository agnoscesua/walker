package Servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;

import Helper.SqlHelper;

@WebServlet("/Data.html")
public class Data extends HttpServlet {
	private static final long serialVersionUID = 1L;
  
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String stationid = request.getParameter("stationid");
		String from = request.getParameter("from");
		String to = request.getParameter("to");
		JSONArray leasedata = SqlHelper.getLeaseNumById(stationid, from, to);
		response.getWriter().write(leasedata + "@wujiu@");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
