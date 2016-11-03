//
//  DiscoverTableViewController.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/4/21.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       visitorView?.setupVisitorInfo(false, imageName: "visitordiscover_image_message", messageText: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
