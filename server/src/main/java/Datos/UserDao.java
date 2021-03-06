package Datos;

import Logic.Auser;
import oracle.jdbc.OracleTypes;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDao extends Datos.InterfaceDao<Auser,String> {


    public UserDao()
    {
        super();
    }

    @Override
    public void insert(Auser r) throws Throwable {
        String sp = "{CALL prc_insert_user(?,?,?,?,?,?,?,?)}";
        CallableStatement pstmt = this.db.getConnection().prepareCall(sp);
        pstmt.setString(1, r.getId());
        pstmt.setString(2, r.getPassword());
        pstmt.setString(3, r.getName());
        pstmt.setString(4, r.getSurnames());
        pstmt.setDouble(5, r.getLatitud());
        pstmt.setDouble(6, r.getLongitud());
        pstmt.setString(7, r.getCellphone());
        pstmt.setInt(8, r.getUsertype());

        boolean flag = pstmt.execute();
        if (flag) {
            throw new Exception("Impossible to insert the user");
        }
    }

    @Override
    public void update(Auser r) throws Throwable {
        String sp = "{CALL prc_update_user(?,?,?,?,?,?,?,?)}";
        CallableStatement pstmt = this.db.getConnection().prepareCall(sp);
        pstmt.setString(1, r.getId());
        pstmt.setString(2, r.getPassword());
        pstmt.setString(3, r.getName());
        pstmt.setString(4, r.getSurnames());
        pstmt.setDouble(5, r.getLatitud());
        pstmt.setDouble(6, r.getLongitud());
        pstmt.setString(7, r.getCellphone());
        pstmt.setInt(8, r.getUsertype() );
        boolean flag = pstmt.execute();
        if (flag) {
            throw new Exception("Impossible to update the user");
        }
    }

    @Override
    public void delete(String id) throws Throwable {
        String sp = "{? = call prc_delete_user(?)}";
        CallableStatement pstmt = this.db.getConnection().prepareCall(sp);
        pstmt.registerOutParameter(1,OracleTypes.CURSOR);
        pstmt.setString(2, id);
        boolean flag = pstmt.execute();
        if (flag) {
            throw new Exception("Impossible to delete the user.");
        }
    }

    @Override
    public Auser get(String id) throws Throwable {
        String sp = "{? = call fn_getone_user(?)}";
        CallableStatement pstmt = this.db.getConnection().prepareCall(sp);
        pstmt.registerOutParameter(1,OracleTypes.CURSOR);
        pstmt.setString(2, id);
        boolean flag = pstmt.execute();
        if (flag) {
            throw new Exception("Impossible to read the user.");
        }
        ResultSet rs = (ResultSet) pstmt.getObject(1);
        if (rs.next()) {
            return instance(rs);
        }
        return null;
    }

    @Override
    public Auser instance(ResultSet rs) throws Throwable {
        try {
            Auser r = new Auser();

            r.setId(rs.getString("ID"));
            r.setPassword(rs.getString("Password"));
            r.setName(rs.getString("Name"));
            r.setSurnames(rs.getString("Surnames"));
            r.setLatitud(rs.getDouble("Latitud"));
            r.setLongitud(rs.getDouble("Longitud"));
            r.setCellphone(rs.getString("Cellphone"));

            return r;
        } catch (SQLException ex) {
            System.out.println(ex.toString());
            return null;
        }
    }

    @Override
    public List<Auser> search() throws Throwable {
        List<Auser> result = new ArrayList();
        try {
            String sp = "{? = call fn_get_user()}";
            CallableStatement pstmt = this.db.getConnection().prepareCall(sp);
            pstmt.registerOutParameter(1, OracleTypes.CURSOR);
            pstmt.execute();
            ResultSet rs = (ResultSet) pstmt.getObject(1);
            while (rs.next()) {
                result.add(instance(rs));
            }
        } finally {
            return result;
        }
    }

    public int login(String id, String password) throws Exception {
        String sp = "{? = call fn_login(?,?)}";
        CallableStatement pstmt = this.db.getConnection().prepareCall(sp);
        pstmt.registerOutParameter(1,OracleTypes.INTEGER);
        pstmt.setString(2, id);
        pstmt.setString(3,password);
        pstmt.execute();
        return pstmt.getInt(1);
    }

    public Auser Loginget(String id, String password) throws Throwable {
        String sp = "{? = call fn_login_get(?,?)}";
        CallableStatement pstmt = this.db.getConnection().prepareCall(sp);
        pstmt.registerOutParameter(1,OracleTypes.CURSOR);
        pstmt.setString(2, id);
        pstmt.setString(3,password);
        boolean flag = pstmt.execute();
        if (flag) {
            throw new Exception("Impossible to read the user.");
        }
        ResultSet rs = (ResultSet) pstmt.getObject(1);
        if (rs.next()) {
            return instance(rs);
        }
        return null;
    }

}
