import { ComponentFixture, TestBed } from '@angular/core/testing';

import { JobApplicationConfirmationPageComponent } from './job-application-confirmation-page.component';

describe('JobApplicationConfirmationPageComponent', () => {
  let component: JobApplicationConfirmationPageComponent;
  let fixture: ComponentFixture<JobApplicationConfirmationPageComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [JobApplicationConfirmationPageComponent]
    });
    fixture = TestBed.createComponent(JobApplicationConfirmationPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
