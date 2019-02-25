//
//  ChatRoomViewController.swift
//  ChatNow
//
//  Created by Zhihui Sun on 21/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    private var viewModel: ChartRoomViewModel!
    private let imagePicker = UIImagePickerController()
    
    public func inject(viewModel: ChartRoomViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        configureSendButton()
        configureImagePickerDelegate()
        viewModel.refreshUIHandler = { [weak self] in
            self?.tableView.reloadData()
            if let rows = self?.viewModel?.numberOfMessages(), rows > 0 {
                let indexPath = IndexPath(row: rows - 1, section: 0)
                self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
        viewModel.observeMessage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    private func configureImagePickerDelegate() {
        imagePicker.delegate = self
    }
    private func configureSendButton() {
        sendButton.layer.cornerRadius = 5
    }
    private func configureTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(ChatMemberCell.nib, forCellReuseIdentifier: "ChatMemberCell")
        tableView.register(ChatMyCell.nib, forCellReuseIdentifier: "ChatMyCell")
        tableView.register(ChatMemberImageCell.nib, forCellReuseIdentifier: "ChatMemberImageCell")
        tableView.register(ChatMyImageCell.nib, forCellReuseIdentifier: "ChatMyImageCell")
        tableView.tableFooterView = UIView()
    }

    private func configureNavigationBar() {
        title = "Tarot Room"
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .plain, target: self, action: #selector(quitRoom))
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    @objc private func quitRoom() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSendButton(_ sender: Any) {
        guard messageTextField.text != "" else { return }
        viewModel.sendMessage(message: messageTextField.text!)
        messageTextField.text = ""
    }
    
    @IBAction func didTapPinButton(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMessages()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.messageCellViewModel(at: indexPath.row)
        var messageCell: UITableViewCell?
        
        if viewModel.isMyMessage(at: indexPath.row) {
            if viewModel.isImageType(at: indexPath.row) {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "ChatMyImageCell")
                (messageCell as? ChatMyImageCell)?.configure(viewModel: cellViewModel)
            } else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "ChatMyCell")
                (messageCell as? ChatMyCell)?.configure(viewModel: cellViewModel)
            }
        } else {
            if viewModel.isImageType(at: indexPath.row) {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "ChatMemberImageCell")
                (messageCell as? ChatMemberImageCell)?.configure(viewModel: cellViewModel)
            } else {
                messageCell = tableView.dequeueReusableCell(withIdentifier: "ChatMemberCell")
                (messageCell as? ChatMemberCell)?.configure(viewModel: cellViewModel)
            }
        }
        return messageCell ?? UITableViewCell()
    }
}

extension ChatRoomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        viewModel.uploadImageMessage(image: chosenImage, imageName: UUID().uuidString)
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

