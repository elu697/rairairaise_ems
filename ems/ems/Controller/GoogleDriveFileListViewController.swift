//
//  GoogleDriveFileListViewController.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/07.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import SVProgressHUD
import UIKit

internal class GoogleDriveFileListViewController: UITableViewController {
    private let isRoot: Bool
    private var currentFolder: String?
    private var folderName: String?
    private var files: [GTLRDrive_File] = []

    private let refresh = UIRefreshControl()

    private lazy var setFetchResult: (GTLRDrive_FileList?, Error?) -> Void = { [weak self] files, error in
        guard let fileList = files?.files else {
            print("\(String(describing: error?.localizedDescription))")
            self?.dismissProgress()
            return
        }
        self?.files = fileList
        DispatchQueue.main.async {
            self?.tableView.reloadData()
            self?.dismissProgress()
        }
    }

    internal init(isRoot: Bool, currentFolder: String? = nil, folderName: String? = nil) {
        self.isRoot = isRoot
        self.currentFolder = currentFolder
        self.folderName = folderName
        super.init(nibName: nil, bundle: nil)
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()

        setRightCloseBarButtonItem()
        setNavigationBarTitleString(title: isRoot ? "GoogleDrive" : folderName ?? "")

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsMultipleSelection = false

        refreshControl = refresh
        refreshControl?.addTarget(self, action: #selector(refreshing), for: .valueChanged)

        NotificationCenter.default.addObserver(self, selector: #selector(signInNotify), name: Notification.Name(GoogleDriveNotify.name.value), object: nil)

        if isRoot {
            googleDriveSignIn()
        } else {
            fetch()
        }
    }

    @objc
    private func refreshing() {
        fetch()
    }

    private func showProgress() {
        if !refresh.isRefreshing {
            SVProgressHUD.show()
        }
    }

    private func dismissProgress() {
        if refresh.isRefreshing {
            refresh.endRefreshing()
        } else {
            SVProgressHUD.dismiss()
        }
    }

    private func showSaveCSVAlert(file: GTLRDrive_File, _ completion: @escaping () -> Void) {
        showAlert(title: "確認", message: "このCSVファイルを読み込みますか？", { _ in
            guard let identifier = file.identifier else { return }
            GoogleDriveWrapper.shared.download(identifier) { data, _ in
                if let data = data, FileIO.save(data: data, fileName: "asset.csv") {
                    SVProgressHUD.showSuccess(withStatus: "読み込みました")
                } else {
                    SVProgressHUD.showError(withStatus: "読み込みに失敗しました")
                }
                completion()
            }
        }, cancelAction: { _ in
            print("calcel")
        }
        )
        return
    }

    private func uploadData(values: [String], _ completion: @escaping () -> Void) {
        let dispatch = Dispatch(label: "upload")
        values.forEach { data in
            var asset = data.components(separatedBy: ",")
            if asset.count < 8 {
                asset.append("")
            }
            dispatch.async {
                DBStore.share.set({ save in
                    save.code = asset[0]
                    save.name = asset[1]
                    save.admin = asset[2]
                    save.user = asset[3]
                    save.location = asset[4]
                    save.quantity = Int(asset[5]) ?? 0
                    save.loss = asset[6] == "TRUE"
                    save.discard = asset[7] == "TRUE"
                }, { error in
                    if let error = error {
                        print("\(error.descript)")
                    }
                    dispatch.leave()
                }
                )
            }
        }

        dispatch.notify(completion)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: GoogleDrive Function
extension GoogleDriveFileListViewController {
    private func googleDriveSignIn() {
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
        GIDSignIn.sharedInstance().presentingViewController = self

        if GIDSignIn.sharedInstance().hasPreviousSignIn() {
            GIDSignIn.sharedInstance().restorePreviousSignIn()
        } else {
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance().signIn()
            }
        }
    }

    @objc
    private func signInNotify() {
        print("signin")
        fetch()
    }
}

// MARK: Network
extension GoogleDriveFileListViewController {
    private func fetchRoot() {
        GoogleDriveWrapper.shared.listFilesInRoot(setFetchResult)
    }

    private func fetchSearch() {
        guard let currentFolder = currentFolder else {
            SVProgressHUD.dismiss()
            refreshControl?.endRefreshing()
            return
        }
        GoogleDriveWrapper.shared.listFilesInFolder(currentFolder, setFetchResult)
    }

    private func fetch() {
        showProgress()
        if isRoot {
            fetchRoot()
        } else {
            fetchSearch()
        }
    }
}

// MARK: UITableView DataSource
extension GoogleDriveFileListViewController {
    override internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }

    override internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        cell.textLabel?.text = files[indexPath.row].name
        switch GoogleDriveMime(rawValue: files[indexPath.row].mimeType ?? "") {
        case .folder:
            cell.imageView?.image = Constants.Image.folder
            cell.imageView?.tintColor = .black

        case .csv:
            cell.imageView?.image = Constants.Image.file
            cell.imageView?.tintColor = .systemBlue

        case .none: ()
        }
        return cell
    }
}

// MARK: UITableView Delegate
extension GoogleDriveFileListViewController {
    override internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = files[indexPath.row]
        guard GoogleDriveMime(rawValue: file.mimeType ?? "") == .folder else {
            showSaveCSVAlert(file: file) { [weak self] in
                guard let value = FileIO.load(fileName: "asset.csv") else { return }
                SVProgressHUD.show()
                self?.uploadData(values: value) {
                    SVProgressHUD.dismiss()
                }
            }
            return
        }

        let vc = GoogleDriveFileListViewController(isRoot: false, currentFolder: file.identifier, folderName: file.name)
        navigationController?.pushViewController(vc, animated: true)
    }
}
