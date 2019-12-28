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
    private let currentFolder: String?
    private static var globalCurrentFolder: String?
    private let folderName: String?
    private let isPDFSelect: Bool
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

    override internal func loadView() {
        view = GoogleDriveFileListView()
    }

    internal init(isRoot: Bool, isPDFSelect: Bool, currentFolder: String? = nil, folderName: String? = nil) {
        self.isRoot = isRoot
        self.currentFolder = currentFolder
        self.folderName = folderName
        self.isPDFSelect = isPDFSelect
        GoogleDriveFileListViewController.globalCurrentFolder = isRoot ? "root" : currentFolder
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
                view.addBtn.addTarget(self, action: #selector(tappedAddBtn), for: .touchUpInside)
            }
            setLeftBackBarButtonItem(action: #selector(logout), image: Constants.Image.logout)
        } else {
            fetch()
        }

        view.updateConstraintsIfNeeded()
    }

    @objc
    private func logout() {
        self.showAlert(title: "サインアウト", message: "Googleからサインアウトしますか？", {_ in
            GIDSignIn.sharedInstance()?.signOut()
            self.closeVC()
//            GIDSignIn.sharedInstance()?.disconnect()
//            self.refreshing()
//            self.files.removeAll()
//            guard let view = self.view as? GoogleDriveFileListView else { return }
//            view.tableView.reloadData()
        }, cancelAction: {_ in
            print("cancel")
        })
    }

    @objc
    private func closeVC() {
        self.navigationController?.dissmissView()
    }

    private func pdfDownloadUpload(assets: [Assets], completion: @escaping (String?, Error?) -> Void) {
        /*PDFDownloader.shared.download(fileName: "qr.pdf", param: assets) { _ in
            guard let currentFolder = GoogleDriveFileListViewController.globalCurrentFolder else {
                completion(nil, GDriveError.noDataAtPath)
                return
            }

            if let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
                let filePath = documentDir.appendingPathComponent("qr.pdf").path
                let mimeType = "application/pdf"
                GoogleDriveWrapper.shared.uploadFile(folderID: currentFolder, filePath: filePath, mimeType: mimeType, completion: completion)
            } else {
                completion(nil, GDriveError.noDataAtPath)
            }
        }*/
    }

    @objc
    private func tappedAddBtn() {
        let alert = UIAlertController(title: "確認", message: "ここにQRコードPDFを生成します", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "管理場所"
            textField.clearButtonMode = .whileEditing
        }
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let text = alert.textFields?.first?.text {
                SVProgressHUD.show()
                /*DBStore.shared.search(field: .location, value: text).done { assets in
                    guard !assets.isEmpty else {
                        SVProgressHUD.dismiss()
                        SVProgressHUD.showError(withStatus: "資産情報が存在しません")
                        return
                    }
                    self?.pdfDownloadUpload(assets: assets) { _, error in
                        SVProgressHUD.dismiss()
                        if error != nil {
                            print(error?.localizedDescription)
                            SVProgressHUD.showError(withStatus: "失敗しました")
                        } else {
                            SVProgressHUD.showSuccess(withStatus: "生成完了")
                        }
                    }
                }.catch { _ in
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "失敗しました")
                }*/
                /*DBStore.share.search(field: .location, value: text) { assets, error in
                    if let assets = assets {
                        guard !assets.isEmpty else {
                            SVProgressHUD.dismiss()
                            SVProgressHUD.showError(withStatus: "資産情報が存在しません")
                            return
                        }
                        self?.pdfDownloadUpload(assets: assets) { _, error in
                            SVProgressHUD.dismiss()
                            if error != nil {
                                print(error?.localizedDescription)
                                SVProgressHUD.showError(withStatus: "失敗しました")
                            } else {
                                SVProgressHUD.showSuccess(withStatus: "生成完了")
                            }
                        }
                    } else {
                        SVProgressHUD.dismiss()
                        SVProgressHUD.showError(withStatus: "失敗しました")
                    }
                }*/
            }
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
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
        /*let dispatch = Dispatch(label: "upload")
        values.forEach { data in
            let asset = data.components(separatedBy: ",")
            if asset.count != 8 {
                SVProgressHUD.showError(withStatus: "CSVがフォーマットに沿っていません")
                return
            }
            dispatch.async(attributes: nil) {
                DBStore.share.set({ save in
                    save.code = asset[0]
                    save.name = !asset[1].isEmpty ? asset[1] : nil
                    save.admin = !asset[2].isEmpty ? asset[2] : nil
                    save.user = !asset[3].isEmpty ? asset[3] : nil
                    save.location = !asset[4].isEmpty ? asset[4] : nil
                    save.quantity = Int(asset[5]) ?? 0
                    save.loss = asset[6] == "TRUE"
                    save.discard = asset[7] == "TRUE"
                }, { error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: error.descript)
                        print("\(error.descript)")
                    }
                    dispatch.leave()
                }
                )
            }
        }

        dispatch.notify {
            completion()
        }*/
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
        if let view = view as? GoogleDriveFileListView {
            view.addBtn.isHidden = false
        }
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
        /*let dispatch = Dispatch(label: "getUploadData")
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
        }*/
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
            cell.imageView?.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
//            if #available(iOS 13.0, *) {
//
//            } else {
//                // Fallback on earlier versions
//            }

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

        print(file.mimeType)

        if GoogleDriveMime(rawValue: file.mimeType ?? "") != .folder {
            guard !isPDFSelect else { return }
            showSaveCSVAlert(file: file) { [weak self] in
                self?.tappedProcess()
                self?.dismiss(animated: true, completion: nil)
            }
            return
        }

        let vc = GoogleDriveFileListViewController(isRoot: false, isPDFSelect: isPDFSelect, currentFolder: file.identifier, folderName: file.name)
        navigationController?.pushViewController(vc, animated: true)
    }
}
