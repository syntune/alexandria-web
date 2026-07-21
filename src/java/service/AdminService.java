/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import utils.PasswordUtil;
import dao.UserDAO;
import dao.BookDAO;
import java.util.List;
import model.User;
/**
 *
 * @author PC
 */
public class AdminService {
    UserDAO udao = new UserDAO();
    BookDAO bdao = new BookDAO();
    
    public List<User> getUsers(){
        return udao.getUsers();
    }
    
    public void insertUser(String username, String password, int roleId){
        
        // User already exists
        if(udao.getUser(username) != null){
            return;
        }
        
        User u = new User(username, PasswordUtil.hashPassword(password), roleId);
        udao.insert(u);
    }
    
    public void deleteUser(String username){
        udao.delete(username);
    }
    
    // Update user based on username
    public void updateUser(String username, String password, int roleId){
        String passwordHash = PasswordUtil.hashPassword(password);
       
        udao.update(username, passwordHash, roleId);
    }
}
