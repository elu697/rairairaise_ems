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
import Material
import SVProgressHUD
import UIKit

internal class GoogleDriveFileListViewController: UIViewController {
    private let isRoot: Bool
    private var currentFolder: String?
    private var folderName: String?
    private var isPDFSelect: Bool
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
            if let view = self?.view as? GoogleDriveFileListView {
                view.tableView.reloadData()
            }
            self?.dismissProgress()
        }
    }

    override func loadView() {
        view = GoogleDriveFileListView()
    }

    internal init(isRoot: Bool, isPDFSelect: Bool, currentFolder: String? = nil, folderName: String? = nil) {
        self.isRoot = isRoot
        self.currentFolder = currentFolder
        self.folderName = folderName
        self.isPDFSelect = isPDFSelect
        super.init(nibName: nil, bundle: nil)
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()

        setRightCloseBarButtonItem(action: #selector(closeVC))
        setNavigationBarTitleString(title: isRoot ? "GoogleDrive" : folderName ?? "")

        guard let view = view as? GoogleDriveFileListView else { return }

        view.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        view.tableView.tableFooterView = UIView(frame: .zero)
        view.tableView.allowsMultipleSelection = false
        view.tableView.delegate = self
        view.tableView.dataSource = self

        view.tableView.refreshControl = refresh
        view.tableView.refreshControl?.addTarget(self, action: #selector(refreshing), for: .valueChanged)

        NotificationCenter.default.addObserver(self, selector: #selector(signInNotify), name: Notification.Name(GoogleDriveNotify.name.value), object: nil)

        if isRoot {
            googleDriveSignIn()
            if isPDFSelect {
                navigationController?.view.layout(view.addBtn).width(48).height(48).bottomRight(bottom: 30, right: 30)
            }
        } else {
            fetch()
        }

        view.updateConstraintsIfNeeded()
    }

    @objc
    private func closeVC() {
        self.navigationController?.dissmissView()
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
            if asset.count != 8 {
                SVProgressHUD.showError(withStatus: "CSVがフォーマットに沿っていません")
//                dispatch.notify {
//                    completion()
//                }
                return
            }
            dispatch.async(attributes: nil) {
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
                        dispatch.leave()
                    }
                }
                )
            }
        }

        dispatch.notify {
            completion()
        }
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
            refresh.endRefreshing()
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

    private func getUploadData(values: [String], completion: @escaping ([Assets]) -> Void) {
        let dispatch = Dispatch(label: "getUploadData")
        var assets: [Assets] = []

        values.forEach { value in
            dispatch.async(attributes: nil) {
                let asset = value.components(separatedBy: ",")
                DBStore.share.search(field: .code, value: asset[0]) { asset, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        guard let asset = asset?.first else { return }
                        assets.append(asset)
                    }
                    dispatch.leave()
                }
            }
        }

        dispatch.notify {
            completion(assets)
        }
    }

    private func tappedProcess() {
        guard let values = FileIO.load(fileName: "asset.csv") else {
            SVProgressHUD.showError(withStatus: "CSVの読み込みに失敗しました")
            return
        }

        SVProgressHUD.show()
        self.uploadData(values: values) {
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "登録完了しました")
        }
    }
}

// MARK: UITableView DataSource
extension GoogleDriveFileListViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let view = view as? GoogleDriveFileListView else { return 0 }
        if files.isEmpty {
            view.emptyLbl.isHiddenWithAlphaAnimation = 1.0
        } else {
            view.emptyLbl.isHiddenWithInteraction = true
        }

        return files.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        cell.textLabel?.text = files[indexPath.row].name
        cell.backgroundColor = .white
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
extension GoogleDriveFileListViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let file = files[indexPath.row]
        guard GoogleDriveMime(rawValue: file.mimeType ?? "") == .folder else {
            showSaveCSVAlert(file: file) { [weak self] in
                self?.tappedProcess()
            }
            return
        }

        let vc = GoogleDriveFileListViewController(isRoot: false, isPDFSelect: isPDFSelect, currentFolder: file.identifier, folderName: file.name)
        navigationController?.pushViewController(vc, animated: true)
    }
}
