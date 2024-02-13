import { Component } from '@angular/core';
import { ServiceService } from '../services/service.service'

@Component({
    selector: 'app-main-page',
    templateUrl: './main-page.component.html',
    styleUrls: ['./main-page.component.css']
})
export class MainPageComponent {
    weatherData: any[] = [];

    constructor(private service: ServiceService) { }

    ngOnInit() {
        this.getWeatherData()
    }

    getWeatherData() {
        this.service.getWeatherForecast().subscribe(data => {
            this.weatherData = data;
            console.log(this.weatherData)
        });
    }
}
