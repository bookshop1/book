package chart;

import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChartService {

	private final ChartMapper chartMapper;

    public List<SalesDTO> getDailySales() {
        return chartMapper.getDailySales();
    }

    public List<SalesDTO> getMonthlySales() {
        return chartMapper.getMonthlySales();
    }

    public List<SalesDTO> getYearlySales() {
        return chartMapper.getYearlySales();
    }
}


