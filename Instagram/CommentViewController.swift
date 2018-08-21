//
//  CommentViewController.swift
//  Instagram
//
//  Created by 浅尾栄志 on 2018/08/20.
//  Copyright © 2018年 jirokirameki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var postData: PostData!
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func postComment(_ sender: Any) {
        // commentDataに必要な情報を取得しておく
        let name = Auth.auth().currentUser?.displayName
        let time = Date.timeIntervalSinceReferenceDate

        // 辞書を作成してFirebaseに保存する
        let commentRef = Database.database().reference().child(Const.PostPath).child(postData.id!).child(Const.CommentPath)
        let commentDic = ["uid": uid, "name": name, "time": String(time), "comment": commentTextView.text!]
        commentRef.childByAutoId().setValue(commentDic)
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
        
        // 全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSourceプロトコルのメソッド
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.comments.count
    }
    
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Cellに値を設定する.
        let comment = postData.comments[indexPath.row]
        cell.textLabel?.text = "\(comment.name!) : \(comment.comment!)"

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: comment.date!)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    // MARK: UITableViewDelegateプロトコルのメソッド
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        if uid == postData.comments[indexPath.row].uid {
            return .delete
        } else {
            return .none
        }
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let comment = postData.comments[indexPath.row]
                        
            // データベースから削除する
            let commentRef = Database.database().reference().child(Const.PostPath).child(postData.id!).child(Const.CommentPath)
            commentRef.child(comment.id!).removeValue()
            
            // 削除する
            self.postData.comments.remove(at: indexPath.row)
            
            // TableViewを再表示する
            self.tableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
