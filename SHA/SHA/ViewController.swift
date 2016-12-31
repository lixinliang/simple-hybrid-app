//
//  ViewController.swift
//  SHA
//
//  Created by 李昕亮 on 2016/12/28.
//  Copyright © 2016年 李昕亮. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    var webView: WKWebView!
    var progressBar: UIProgressView!
    var initialized: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 视图
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.evaluateJavaScript("navigator.userAgent") { (userAgent, error) in
            self.webView.customUserAgent = userAgent as! String + " sha/1.0 field/test"
        }
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(URLRequest(url: URL(string: "http://web.me.yy.com/s/sdk/test.html")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if initialized {

        } else {
            // 初始化成功
            initialized = true
            
            // 白底
            let cover = view.subviews.last
            
            // 添加视图
            view.insertSubview(webView, belowSubview: cover!)
            
            // 状态栏
            let statusBar = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
            statusBar.frame.size = CGSize(width: view.frame.width, height: 20)
            statusBar.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
            view.insertSubview(statusBar, aboveSubview: webView)
            
            // 控制栏
            let controlBar = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
            controlBar.layer.position.y = view.frame.height - 40
            controlBar.frame.size = CGSize(width: view.frame.width, height: 50)
            controlBar.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
            controlBar.layer.zPosition = 9
            view.insertSubview(controlBar, aboveSubview: webView)
            
            // 按钮尺寸
            let size = view.frame.width / 3
            
            // 后退按钮
            let backward = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: 40))
            backward.setImage(UIImage(named: "arrow-back"), for: UIControlState.normal)
            backward.addTarget(self, action: #selector(backwardAction(button:)), for: .touchUpInside)
            controlBar.addSubview(backward)
            
            // 刷新按钮
            let refresh = UIButton(frame: CGRect(x: size, y: 0, width: size, height: 40))
            refresh.setImage(UIImage(named: "refresh"), for: UIControlState.normal)
            refresh.addTarget(self, action: #selector(refreshAction(button:)), for: .touchUpInside)
            controlBar.addSubview(refresh)
            
            // 前进按钮
            let forward = UIButton(frame: CGRect(x: size * 2, y: 0, width: size, height: 40))
            forward.setImage(UIImage(named: "arrow-forward"), for: UIControlState.normal)
            forward.addTarget(self, action: #selector(forwardAction(button:)), for: .touchUpInside)
            controlBar.addSubview(forward)
            
            // 进度条
            progressBar = UIProgressView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 20))
            progressBar.backgroundColor = UIColor.clear
            progressBar.trackTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
            progressBar.progress = 0.0
            view.insertSubview(progressBar, aboveSubview: webView)
            
            // 遮罩退场
            let leave = CAKeyframeAnimation(keyPath: "bounds")
            leave.beginTime = CACurrentMediaTime() + 1
            leave.duration = 1
            leave.keyTimes = [0, 0.4, 1]
            leave.values = [NSValue(cgRect: CGRect(x: 0, y: 0, width: 100, height: 100)),
                            NSValue(cgRect: CGRect(x: 0, y: 0, width: 85, height: 85)),
                            NSValue(cgRect: CGRect(x: 0, y: 0, width: 4500, height: 4500))]
            leave.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
                                     CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)]
            leave.isRemovedOnCompletion = false
            leave.fillMode = kCAFillModeForwards
            view.layer.mask?.add(leave, forKey: "zoomAnimation")
            
            // 白底淡出
            UIView.animate(withDuration: 0.3, delay: 1.4, options: .curveLinear, animations: {
                cover?.alpha = 0
            }) { (_) in
                cover?.removeFromSuperview()
                self.view.layer.mask = nil
            }
            
            // 视图抖动
            let rebound = CAKeyframeAnimation(keyPath: "transform")
            rebound.beginTime = CACurrentMediaTime() + 1.1
            rebound.duration = 0.6
            rebound.keyTimes = [0, 0.5, 1]
            rebound.values = [NSValue(caTransform3D: CATransform3DIdentity),
                              NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.1, 1.1, 1)),
                              NSValue(caTransform3D: CATransform3DIdentity)]
            view.layer.add(rebound, forKey: "transformAnimation")
            view.layer.transform = CATransform3DIdentity
        }

    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        //todo
        print("⚠️alert:\(message)")
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default) { (action) in
            print("\(action)")
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        //todo
        print("⚠️confirm:\(message)")
        let confirm = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
            print("\(action)")
        })
        confirm.addAction(UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("\(action)")
        })
        self.present(confirm, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        //todo
        print("⚠️prompt:\(prompt)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //todo
        //print("💣失败")
        //let path = Bundle.main.path(forResource: "index", ofType: "html")
        //let url = URL(fileURLWithPath: path!)
        //print("\(url)")
        //webView.load(<#T##data: Data##Data#>, mimeType: <#T##String#>, characterEncodingName: <#T##String#>, baseURL: <#T##URL#>)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if initialized {
                let current = progressBar.progress
                let percentage = change![NSKeyValueChangeKey(rawValue: "new")] as! Float
                if current > percentage  {
                    progressBar.layer.removeAllAnimations()
                    progressBar.progress = 0.0
                    progressBar.layer.opacity = Float(1)
                } else {
                    if percentage == 1.0 {
                        self.progressBar.setProgress(percentage, animated: true)
                        UIView.animate(withDuration: 0.8, delay: 0, options: .curveLinear, animations: {
                            self.progressBar.layer.opacity = Float(0)
                        })
                    } else {
                        progressBar.setProgress(percentage, animated: true)
                    }
                }
            }
        }
    }
    
    func backwardAction ( button: UIButton ) {
        webView.goBack()
    }
    
    func refreshAction ( button: UIButton ) {
        webView.reload()
    }
    
    func forwardAction ( button: UIButton ) {
        webView.goForward()
    }
}

