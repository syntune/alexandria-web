package dao;

import java.util.*;
import model.User;

public class UserDAO extends MyDAO {

    public List<User> getUsers() {
        List<User> t = new ArrayList<>();
        xSql = "select * from Users";
        try {
            ps = con.prepareStatement(xSql);
            rs = ps.executeQuery();
            String xName, xPass;
            int xId;
            User x;
            while (rs.next()) {
                xId = rs.getInt("RoleID");
                xName = rs.getString("Username");
                xPass = rs.getString("PasswordHash");
                x = new User(xName, xPass, xId);
                t.add(x);
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return (t);
    }

    public User getUser(String xName) {
        xSql = "select * from Users where Username = ?";

        String xPass;
        int xId;
        User x = null;
        try {
            ps = con.prepareStatement(xSql);
            ps.setString(1, xName);
            rs = ps.executeQuery();
            /* The cursor on the rs after this statement is in the BOF area, i.e. it is before the first record.
         Thus the first rs.next() statement moves the cursor to the first record
             */

            if (rs.next()) {
                xId = rs.getInt("RoleID");
                xName = rs.getString("Username");
                xPass = rs.getString("PasswordHash");
                x = new User(xName, xPass, xId);
            } else {
                x = null;
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
        }
        return (x);
    }
    
    public int getUserTier(String xName) {
        xSql = "select * from Users u join UserSubscription us on u.UserID = us.UserID join SubscriptionPlan s on us.PlanID = s.PlanID where Username = ?";

        int tier = 1;
        try {
            ps = con.prepareStatement(xSql);
            ps.setString(1, xName);
            rs = ps.executeQuery();
            /* The cursor on the rs after this statement is in the BOF area, i.e. it is before the first record.
         Thus the first rs.next() statement moves the cursor to the first record
             */

            if (rs.next()) {
                tier = rs.getInt("Tier");
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
        }
        return tier;
    }

    public void insert(User x) {
        xSql = "insert into Users (Username,PasswordHash,RoleID) values (?,?,?)";
        try {
            ps = con.prepareStatement(xSql);
            ps.setString(1, x.getUsername());
            ps.setString(2, x.getPassword());
            ps.setInt(3, x.getRoleId());
            ps.executeUpdate();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(String username) {
        xSql = "delete from Users where Username=?";
        try {
            ps = con.prepareStatement(xSql);
            ps.setString(1, username);
            ps.executeUpdate();
            //con.commit();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
 
    public void update(String username, String passwordHash, int roleId) {
       xSql = "update Users set PasswordHash=?, RoleID=? where Username=?";
       try {      
          ps = con.prepareStatement(xSql);
          ps.setString(1, passwordHash);
          ps.setInt(2, roleId);
          ps.setString(3, username);
          ps.executeUpdate();
          ps.close();
       }
        catch(Exception e) {
          e.printStackTrace();
        }
    }
}
