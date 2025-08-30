package bag;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("bagService")
public class BagService {
    @Autowired
    BagMapper mapper;

    // 특정 유저의 장바구니 항목 가져오기
    public List<BagBook> getBagItems(int u_id) {
        return mapper.findBagItemsByUserId(u_id);
    }

    // 총 가격 계산
    public int totalPrice(int u_id) {
        return mapper.totalPrice(u_id);
    }

    // 장바구니에서 특정 책 삭제
    public void deleteBag(int u_id, int b_id) {
        mapper.deleteFromBag(u_id, b_id);
    }

    // 로그인 유저 - 장바구니에 추가/수량 증가
    public void addOrUpdateBag(int u_id, int b_id, int quantity) {
        Integer count = mapper.countItem(u_id, b_id);
        if (count != null && count > 0) {
            // 기존 수량 가져와서 추가
            int currentQty = mapper.getQuantity(u_id, b_id);
            mapper.updateQty(u_id, b_id, currentQty + quantity);
        } else {
            mapper.insertBag(u_id, b_id, quantity);
        }
    }

    // 책 ID로 책 정보 가져오기 (비로그인 장바구니용)
    public BagBook getBookById(int b_id) {
        return mapper.findBookById(b_id);
    }
    
    /** 장바구니 항목 업데이트 (전체) */
    public void updateAllBagItems(Integer uId, List<BagBook> bagItems) {
        if (bagItems != null && !bagItems.isEmpty()) {
            for (BagBook item : bagItems) {
                Integer existingCount = mapper.countItem(uId, item.getB_id());

                if (existingCount > 0) {
                    // 이미 있으면 수량 업데이트
                    mapper.updateQty(uId, item.getB_id(), item.getQuantity());
                } else {
                    // 없으면 새로 추가
                    mapper.insertBag(uId, item.getB_id(), item.getQuantity());
                }
            }
        }
    }
}