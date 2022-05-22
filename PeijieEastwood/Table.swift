import UIKit

class Table: UIButton {
    var iNumber:Int!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBackgroundImage(UIImage.init(named: "table_y"), for: .normal)
        self.setBackgroundImage(UIImage.init(named: "table_s"), for: .selected)
        self.setBackgroundImage(UIImage.init(named: "table_n"), for: .disabled)//Set the image style of the table in the view and set the type of the table to UIButton. The Frame type is set to CGRect, which is consistent with the //Bubble type of Assignment2
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
