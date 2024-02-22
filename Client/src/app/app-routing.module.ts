import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginPageComponent } from './components/login-page/login-page.component';
import { AuthGuard } from './auth.guard';
import { JobsPageComponent } from './components/jobs-page/jobs-page.component';
import { JobDetailsPageComponent } from './components/job-details-page/job-details-page.component';
import { JobApplicationConfirmationPageComponent } from './components/job-application-confirmation-page/job-application-confirmation-page.component';

const routes: Routes = [
    { path: '', redirectTo: 'login', pathMatch: 'full' },
    { path: 'login', component: LoginPageComponent },
    { path: 'jobs', component: JobsPageComponent, canActivate: [AuthGuard] },
    { path: 'jobs/:jobId', component: JobDetailsPageComponent, canActivate: [AuthGuard] },
    { path: 'jobs/:jobId/confirmation', component: JobApplicationConfirmationPageComponent, canActivate: [AuthGuard] }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
