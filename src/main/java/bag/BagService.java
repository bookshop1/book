package bag;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("bagService")
public class BagService {
	@Autowired
	BagMapper mapper;
	
	public List<BagBook> getBagItems(int u_id) {
        return mapper.findBagItemsByUserId(u_id);
    }
	
	public int totalPrice(int u_id) {
		return mapper.totalPrice(u_id);
	}
	public void deleteBag(int u_id, int b_id) {
		mapper.deleteFromBag(u_id, b_id);
	}
}
