import { ComponentFixture, TestBed } from '@angular/core/testing';

import { JobDetailsPageComponent } from './job-details-page.component';

describe('JobDetailsPageComponent', () => {
  let component: JobDetailsPageComponent;
  let fixture: ComponentFixture<JobDetailsPageComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [JobDetailsPageComponent]
    });
    fixture = TestBed.createComponent(JobDetailsPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
