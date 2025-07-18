package bag;

import java.util.List;

public class BagBookListWrapper {
	private List<BagBook> bagItems;

    public List<BagBook> getBagItems() {
        return bagItems;
    }

    public void setBagItems(List<BagBook> bagItems) {
    	System.out.println("✔ bagItems setter called. size = " + (bagItems != null ? bagItems.size() : "null"));
        this.bagItems = bagItems;
    }
}
