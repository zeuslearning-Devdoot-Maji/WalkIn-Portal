import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule } from '@angular/forms';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { MainPageComponent } from './main-page/main-page.component';
import { LoginPageComponent } from './components/login-page/login-page.component';
import { LoginFormComponent } from './components/login-page/login-form/login-form.component';
import { NavbarComponent } from './shared/navbar/navbar.component';
import { JobsPageComponent } from './components/jobs-page/jobs-page.component';
import { JobDetailsPageComponent } from './components/job-details-page/job-details-page.component';
import { JobApplicationConfirmationPageComponent } from './components/job-application-confirmation-page/job-application-confirmation-page.component';

@NgModule({
    declarations: [
        AppComponent,
        MainPageComponent,
        LoginPageComponent,
        LoginFormComponent,
        NavbarComponent,
        JobsPageComponent,
        JobDetailsPageComponent,
        JobApplicationConfirmationPageComponent
    ],
    imports: [
        AppRoutingModule,
        BrowserModule,
        FormsModule,
        HttpClientModule
    ],
    providers: [],
    bootstrap: [AppComponent]
})
export class AppModule { }
