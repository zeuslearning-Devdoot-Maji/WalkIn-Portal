import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
    providedIn: 'root'
})
export class ServiceService {
    private apiUrl = 'http://localhost:5193/weatherforecast';

    constructor(private http: HttpClient) { }

    getWeatherForecast(): Observable<any> {
        return this.http.get<any>(this.apiUrl);
    }
}
