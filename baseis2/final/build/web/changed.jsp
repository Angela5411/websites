<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%-- 
    Document   : changed
    Created on : 12 Μαϊ 2017, 9:58:36 μμ
    Author     : Angela
--%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="JavaFiles.*"%>
<%@page import="java.util.ArrayList"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
html { 
  background: url(./picture/reg.jpg) no-repeat center center fixed; 
  -webkit-background-size: cover;
  -moz-background-size: cover;
  -o-background-size: cover;
  background-size: cover;
}


</style>
        
    </head>
    <body>
     	
		
    <%     User u=new User();

	u.password=request.getParameter("password");
        String password=request.getParameter("newpassword");
	u.am= Integer.parseInt(request.getParameter("am")); 
        u.name=request.getParameter("name");
        u.surname=request.getParameter("surname");
        u.school= Integer.parseInt(request.getParameter("school"));
        u.cv=request.getParameter("cv");
        u.bdate=Date.valueOf(request.getParameter("bday"));
	
        
        
        Boolean found;
        String  URL;
        Class.forName("com.mysql.jdbc.Driver");
        String DB = "jdbc:mysql://localhost:3306/final?user=root";
        Connection myConnection = DriverManager.getConnection(DB);
        Statement SMT = myConnection.createStatement();
        String sql="SELECT * FROM student WHERE s_no='"+u.am+"'AND password='"+u.password+"' ";
        ResultSet rs=SMT.executeQuery(sql);
        found= rs.first();
        SMT.close();
        myConnection.close();
        //out.println(found);
        if (!found){  
            URL = "change.jsp?p1="+u.am+""; 
            response.sendRedirect(URL);
        }
        else{
       
        
        ArrayList<Photo> photos = new ArrayList<Photo>();
        String[] temp=request.getParameterValues("photo");
        for(int i=0;i<temp.length;i++)
        {
            Photo t= new Photo();
            t.s_no=u.am;
            t.p_no=i;
            t.photo=temp[i];
            photos.add(t);
        }
        
        
        ArrayList<Video> videos=new ArrayList<Video>();
        temp=request.getParameterValues("video");
        for(int i=0;i<temp.length;i++)
        {
          Video t0=new Video();
          t0.s_no=u.am;
          t0.v_no=i;
          t0.video=temp[i];
          videos.add(t0);
        }

        
        ArrayList<Interest> interests = new ArrayList<Interest>();
        temp=request.getParameterValues("interest1");
        for(int i=0;i<temp.length;i++)
        {
            Interest t1= new Interest();
            t1.s_no=u.am;
            t1.i_no=Integer.parseInt(temp[i]);
            t1.setInterest();
            interests.add(t1);
        }
        
        
        
        ArrayList<Hobby> hobbies = new ArrayList<Hobby>();
        temp=request.getParameterValues("interest2");
        for(int i=0;i<temp.length;i++)
        {
            Hobby t2= new Hobby();
            t2.s_no=u.am;
            t2.h_no=Integer.parseInt(temp[i]);
            t2.setHobby();
            hobbies.add(t2);
        }
        
        
        
        ArrayList<Language> languages = new ArrayList<Language>();
        temp=request.getParameterValues("lang");
        String level[]=request.getParameterValues("level");
        for(int i=0;i<temp.length;i++)
        {
            Language t3=new Language();
            t3.s_no=u.am;
            t3.language=temp[i];
            t3.level=level[i];
            languages.add(t3);
        }
        
        
        
        
        ArrayList<Quote> quotes = new ArrayList<Quote>();
        temp=request.getParameterValues("quote");
        for(int i=0;i<temp.length;i++)
        {
            Quote t4= new Quote();
            t4.s_no=u.am;
            t4.quote=temp[i];
            t4.q_no=i;
            quotes.add(t4);
        }
        







        // Load the driver
        Class.forName("com.mysql.jdbc.Driver");
        // Define the connection parameters
        // Connect to the database
        myConnection = DriverManager.getConnection(DB);
        // Create object to execute statements
        Statement myStatement = myConnection.createStatement();
        String sqlString= new String();
        if(! password.equals(u.password) && !password.isEmpty())
        {
                sqlString = "UPDATE student set password='"+password+"' where s_no='"+u.am+"' ";
                myStatement.executeUpdate(sqlString);
        }
        sqlString = "UPDATE student set name='"+u.name+"' where s_no='"+u.am+"' ";
        myStatement.executeUpdate(sqlString);

        sqlString = "UPDATE student set surname='"+u.surname+"' where s_no='"+u.am+"' ";
        myStatement.executeUpdate(sqlString);

        sqlString = "UPDATE student set birthdate='"+u.bdate+"' where s_no='"+u.am+"' ";
        myStatement.executeUpdate(sqlString);
        
        String str = "update student set cv=? where s_no=?";
        PreparedStatement update = myConnection.prepareStatement(str);
        update.setString(1, u.cv);
        update.setInt(2,u.am);
        update.executeUpdate();

        
        
        sqlString = "UPDATE student set sch_no='"+u.school+"' where s_no='"+u.am+"' ";
        myStatement.executeUpdate(sqlString);

     
        
        
        sqlString = "DELETE FROM photos WHERE s_no='"+u.am+"' ";
	myStatement.executeUpdate(sqlString);
        
	Photo t=new Photo();
        for(int i=0;i<photos.size();i++)
        {
            t=photos.get(i);
            sqlString = "INSERT INTO photos(s_no,p_no,photo) VALUES('"+t.s_no+"','"+t.p_no+"','"+t.photo+"')";
            myStatement.executeUpdate(sqlString);
        }
        
        
        
        
        sqlString = "DELETE FROM videos WHERE s_no='"+u.am+"' ";
	myStatement.executeUpdate(sqlString);
        
        Video t0=new Video();
        for(int i=0;i<videos.size();i++)
        {
            t0=videos.get(i);
            int index= t0.video.indexOf("watch?v=");
            if(index>0)
                t0.video=t0.embed(t0.video);
            sqlString = "INSERT INTO videos(s_no,v_no,video) VALUES('"+t0.s_no+"','"+t0.v_no+"','"+t0.video+"')";
            myStatement.executeUpdate(sqlString);
        }
       
        	
        
        sqlString = "DELETE FROM languages WHERE s_no='"+u.am+"' ";
	myStatement.executeUpdate(sqlString);
		
        Language t3=new Language();
        for(int i=0;i<languages.size();i++)
        {
            t3=languages.get(i); 
            sqlString = "INSERT INTO languages(s_no,language,level) VALUES('"+t3.s_no+"','"+t3.language+"','"+t3.level+"')";
            myStatement.executeUpdate(sqlString);
        }

		
	sqlString = "DELETE FROM interests WHERE s_no='"+u.am+"'";
	myStatement.executeUpdate(sqlString);
		
        Interest t1= new Interest();
        for(int i=0;i<interests.size();i++)
        {
            t1=interests.get(i);
            sqlString = "INSERT INTO interests(s_no,i_no) VALUES('"+t1.s_no+"','"+t1.i_no+"')";
            myStatement.executeUpdate(sqlString);
        }
        
		
	sqlString = "DELETE FROM hobbies WHERE s_no='"+u.am+"'";
	myStatement.executeUpdate(sqlString);
		
        Hobby t2= new Hobby();
        for(int i=0;i<hobbies.size();i++)
        {
            t2=hobbies.get(i);
            sqlString = "INSERT INTO hobbies(s_no,h_no) VALUES('"+t2.s_no+"','"+t2.h_no+"')";
            myStatement.executeUpdate(sqlString);
        } 
		


	sqlString = "DELETE FROM quotes WHERE s_no='"+u.am+"'";
	myStatement.executeUpdate(sqlString);
		
	Quote t4= new Quote();
        for(int i=0;i<quotes.size();i++)
        {
            t4=quotes.get(i);
            String SQL = "INSERT INTO quotes(q_no,s_no,quote,q_date) VALUES(?,?,?,?)";
            PreparedStatement updateemp = myConnection.prepareStatement(SQL);
            updateemp.setInt(1,t4.q_no);
            updateemp.setInt(2,t4.s_no);
            updateemp.setString(3, t4.quote);
            updateemp.setDate(4,t4.date);
            updateemp.executeUpdate();
        }
        
	myStatement.close(); 
        myConnection.close();
        
        URL = "profile.jsp?p1="+u.am+"&flag=true"; 		
        response.sendRedirect(URL); 
  }
       
%>
	
	
	</body>
</html>
