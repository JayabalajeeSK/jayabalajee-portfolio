package com.jb.jayabalajee_portfolio.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
@Controller
public class PortfolioController {


    @GetMapping("/portfolio")
    public String showPortfolio() {
        return "portfolio"; // Load portfolio.html
    }
}
