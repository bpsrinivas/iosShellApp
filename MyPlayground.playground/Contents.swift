//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"
var str2 = "learntron://printOnIosFromJS?str=This%20is%20some%20random%20text%20from%20js%20file&str1=string%202";


func getQueryParamFromStr(str:String) -> [String:String]{
    let str1 = str.stringByRemovingPercentEncoding!;
    let components = str1.componentsSeparatedByString("?");
    print(components)
    let paramString = components[1];
    let paramComponents = paramString.componentsSeparatedByString("&");
    var d = [String:String]();
    
    for paramsComp in paramComponents{
        var pair = paramsComp.componentsSeparatedByString("=");
        d.updateValue(pair[1], forKey: pair[0]);
    }
    print(d);
    return d;
}

getQueryParamFromStr(str2)["str"];

