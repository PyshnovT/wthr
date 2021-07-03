import UIKit

final class TabBar: UIView {

    struct Item {
        let image: UIImage?
    }

    var onTap: ((Int) -> Void)?

    var isMiddleButtonEnabled: Bool = true {
        didSet {
            middleButton.isEnabled = isMiddleButtonEnabled
            buttons.first { $0.tag == middleButton.tag }?.isEnabled = isMiddleButtonEnabled

            middleButton.alpha = isMiddleButtonEnabled ? 1 : 0.8
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Views

    private lazy var middleImageView = UIImageView(image: AppConstants.Images.TabBar.change)

    private lazy var middleButton: UIControl = {
        let button = UIControl()
        button.tag = 1
        button.addTarget(self, action: #selector(handleItemTap(button:)), for: .touchDown)
        button.addSubview(middleImageView)
        return button
    }()

    private lazy var separatorView = UIView(backgroundColor: AppConstants.Color.separatorGray)

    private lazy var contentView = UIView()

    private var buttons: [TabBarControl] = []

    // MARK: - Setup

    private func setup() {
        backgroundColor = AppConstants.Color.white
        addSubview(separatorView)
        addSubview(contentView)
    }

    // MARK: - Reload

    var items: [Item] = [] {
        didSet {
            reload()
        }
    }

    var selectedIndex: Int = 0 {
        didSet {
            renderSelectedItem()
        }
    }

    private func reload() {
        contentView.subviews.forEach { $0.removeFromSuperview() }

        let buttons: [TabBarControl] = items.enumerated().map { (i, item) in
            let button = TabBarControl(frame: .zero)
            button.tag = i
            button.addTarget(self, action: #selector(handleItemTap(button:)), for: .touchDown)
            button.imageView.image = item.image?.withRenderingMode(.alwaysTemplate)
            return button
        }

        buttons.forEach(contentView.addSubview)

        self.buttons = buttons

        renderSelectedItem()

        addSubview(middleButton)

        setNeedsLayout()
    }

    private func renderSelectedItem() {
        buttons.enumerated().forEach { (i, button) in
            button.tintColor = i == selectedIndex ? Constants.selectedColor : Constants.deselectedColor
        }

        middleImageView.image = selectedIndex == middleButton.tag
            ? AppConstants.Images.TabBar.change
            : AppConstants.Images.TabBar.disabledChange
    }

    // MARK: - Actions

    @objc private func handleItemTap(button: UIButton) {
        onTap?(button.tag)
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        separatorView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: Constants.separatorHeight)
        contentView.frame = bounds.increaseHeightBy(-safeAreaInsets.bottom)

        let buttonsCount = contentView.subviews.count
        let buttonWidth = bounds.width / CGFloat(max(1, buttonsCount))

        buttons.enumerated().forEach { (i, button) in
            button.frame = CGRect(
                x: buttonWidth * CGFloat(i),
                y: 0,
                width: buttonWidth,
                height: contentView.bounds.height
            )
        }

        middleButton.frame = Constants.iconSize
            .toRect()
            .centrizeHorizontally(in: bounds)
            .withY(-24)
        middleImageView.frame = middleButton.bounds
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let pointIsInside = super.point(inside: point, with: event)

        if pointIsInside == false {
            for subview in subviews {
                let pointInSubview = subview.convert(point, from: self)
                if subview.point(inside: pointInSubview, with: event) {
                    return true
                }
            }
        }

        return pointIsInside
    }

}

private enum Constants {
    static let iconSize = CGSize(width: 50, height: 64)
    static let separatorHeight: CGFloat = 1
    static let selectedColor = AppConstants.Color.orange
    static let deselectedColor = AppConstants.Color.tabBarGray
}
