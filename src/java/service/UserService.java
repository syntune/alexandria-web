/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import utils.PasswordUtil;
import dao.UserDAO;
import model.User;
import dto.LoginDTO;

/**
 *
 * @author PC
 */
public class UserService {
    UserDAO udao = new UserDAO();
    
    public LoginDTO verifyUser(String username, String password) {
        User u = udao.getUser(username);
        if(u == null){
            return new LoginDTO(false, "User not found!", null);
        }
        
        String hash = u.getPassword();
        if(!PasswordUtil.verifyPassword(password, hash)){
            return new LoginDTO(false, "Password not found!", null);
        }
        
        return new LoginDTO(true, "success", u);
    }
    
    public LoginDTO signUpUser(String username, String password){
        User u = udao.getUser(username);
        if(u != null){
            return new LoginDTO(false, "User already found!", null);
        }
        
        User x = new User(username, PasswordUtil.hashPassword(password), 1);
        udao.insert(x);
        return new LoginDTO(true, "success", x);
    }
}
