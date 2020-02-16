require("dotenv").config()
const express = require("express");
const bodyParser = require("body-parser");
const ejs = require("ejs");
const mongoose = require("mongoose");
const md5 = require("md5");

const app = express();

app.set("view engine", "ejs");

app.use(express.static("public"));
app.use(bodyParser.urlencoded({extended: true}));

mongoose.connect("mongodb://localhost:27017/grievanceDB", {useNewUrlParser: true});

let userSchema = new mongoose.Schema({
    name: String,
    username: String,
    password: String,
    upvoteList: [String]
});

let User = mongoose.model("User", userSchema);

let issueSchema = new mongoose.Schema({
    title: String,
    content: String,
    upvotes: Number
});

let Issue = mongoose.model("Issue", issueSchema);

app.route("/")

.get(function(req, res){
    res.render("login");
})

.post(function(req, res){
    const user = req.body.username;
    User.findOne({username: user}, function(err, foundUser){
        if(err)
            res.send(err);
        else{
            if (foundUser){
                if(foundUser.password === md5(req.body.password)){
                    res.redirect("/home?valid=" + encodeURIComponent(foundUser._id));
                }
                else
                    res.redirect('/?error=' + encodeURIComponent('Password_mismatch'));
            }
            else{
                res.redirect('/?error=' + encodeURIComponent('No_user_found'));
            }
        }
    });
})

.delete(function(req, res){
    User.deleteMany(function(err){
        if (err)
            res.send(err);
        else
            res.send("Successfully deleted");
    });
});

app.route("/signup")

.get(function(req, res){
    res.render("signup");
})

.post(function(req, res){
    let newUser = new User({
        name: req.body.name,
        username: req.body.username,
        password: md5(req.body.password),
    });
    newUser.save(function(err){
        if(err)
            res.send(err);
        else{
            res.redirect("/");
        }
    });
});

app.route("/home")

.get(function(req, res){
    let passedVariable = req.query.valid;
    let newList = [];
    Issue.find({}, function(err, foundList){
        if(!err){
            foundList.forEach(function(issue){
                User.find({}, function(err, userList){
                    if(!err){
                        userList.forEach(function(user){
                            if(user.upvoteList.includes(issue.title))
                                issue.upvotes = issue.upvotes + 1;
                        });
                    }
                });
                issue.save();
                newList.push(issue);
            });
            res.render("home", {list: newList, Id: passedVariable});
        }
    });
})

.post(function(req, res){
    Issue.findOne({_id: req.body.upvote}, function(err, foundIssue){
        if(!err){
            User.findOne({_id: req.body.userId}, function(err, foundUser){
                if(!err){
                    if (!(foundUser.upvoteList.includes(foundIssue.title))){
                        foundUser.upvoteList.push(foundIssue.title);
                        foundIssue.upvotes = foundIssue.upvotes + 1;
                        res.redirect("/home?valid=" + encodeURIComponent(req.body.userId));
                    }
                }
            });
        }
    });
});

app.route("/prescription")

.get(function(req, res){
    res.render("prescription", {Id: req.query.valid});
})

.post(function(req, res){
    if (req.body.title && req.body.content){
        let newIssue = new Issue({
            title: req.body.title,
            content: req.body.content,
            upvotes: 1
        });
        newIssue.save(function(err){
            if(!err){
                User.findOne({_id: req.body.usrId}, function(err, foundUser){
                    if (!err){
                        foundUser.upvoteList.push(newIssue.title);
                    } 
                });
                res.redirect("/home?valid=" + encodeURIComponent(req.body.userId));
            }
        });
    }
    else    
        res.redirect("/complaint?valid=" + encodeURIComponent(req.body.userId));
});

app.route("/reset")

.get(function(req, res){
    res.render("reset");
})

.post(function(req, res){
    const code = Math.floor(Math.random() * 10000);
    const codeText = 'Enter the following 4-digit code - ' + code;
    const msg = {
        to: res.username,
        from: "negishubham3503@gmail.com",
        subject: 'Please reset your password',
        text: codeText,
        html: '<strong>Enter the following 4-digit code</strong><br>',
    };
    sgMail.send(msg);
    res.render("password", {email: res.username, resetCode: code});
});

app.route("/newPassword")

.post(function(req, res){
    if (req.body.code === req.body.initial){
        User.findOne({username: req.body.reset}, function(err, foundUser){
            if(!err){
                if (foundUser){
                    foundUser.password = req.body.password;
                    foundUser.save(function(err){
                        if(!err)
                            res.redirect("/");
                    });
                }
                else{
                    res.redirect("/reset?error=" + encodeURIComponent('No_user_found.Try_again)'));
                }
            }
        });
    }
});

app.listen(3000, function(){
    console.log("Server is running on port 3000");
});