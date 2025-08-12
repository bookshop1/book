package pay;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import bag.BagBook;

@Service
public class PayService {
	
	@Autowired
	PayMapper mapper;
	
	public List<BagBook> getBagItems(int userId) {
        return mapper.findBagItemsByUserId(userId);
    }
	
	public int totalPrice(int userId) {
		return mapper.totalPrice(userId);
	}
	
	@Transactional
	public void payment(Payment payment, @Param("userId") int userId, List<BagBook> bagItems) {
		int nextPaymentId = mapper.getNextPaymentId();
	    payment.setPaymentId(nextPaymentId);
	    payment.setUserId(userId);

	    // 총 결제 금액 계산
	    int totalPrice = bagItems.stream().mapToInt(i -> i.getPrice() * i.getQuantity()).sum();
	    payment.setPrice(totalPrice);

	    // MyBatis에 넣을 Map 준비
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("paymentId", nextPaymentId);
	    paramMap.put("userId", userId);
	    paramMap.put("name", payment.getName());
	    paramMap.put("num", payment.getNum());
	    paramMap.put("address", payment.getAddress());
	    paramMap.put("post", payment.getPost());
	    paramMap.put("detailAddress", payment.getDetailAddress());
	    paramMap.put("items", bagItems);

	    mapper.insertPayment(paramMap);
	    
	    for (BagBook item : bagItems) {
            mapper.insertPaymentItem(nextPaymentId, userId, item);
        }
	}
	
	public List<Payment> getPaymentHistoryByUserId(int userId) {
        return mapper.getPaymentHistoryByUserId(userId);
    }

}
