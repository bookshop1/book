package chart;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/chart")
@RequiredArgsConstructor
public class ChartController {

	@Autowired
	private final ChartService chartService;

    @GetMapping("/daily")
    public List<SalesDTO> getDailySales() {
        return chartService.getDailySales();
    }

    @GetMapping("/monthly")
    public List<SalesDTO> getMonthlySales() {
        return chartService.getMonthlySales();
    }

    @GetMapping("/yearly")
    public List<SalesDTO> getYearlySales() {
        return chartService.getYearlySales();
    }
}

